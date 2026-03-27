resource "aws_instance" "catalogue" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.private_subnet_id
  vpc_security_group_ids = [local.catalogue_sg_id]

  tags = merge(
    { Name = "${var.project}-${var.environment}-catalogue" }, local.common_tags
  )
}

#configure 

resource "terraform_data" "catalogue" {
  triggers_replace = aws_instance.catalogue.id

  connection {
    type     = "ssh"
    port     = 22
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"      # Local file path
    destination = "/tmp/bootstrap.sh" # Destination path on the remote machine
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue ${var.environment} ${var.app_version}"
    ]
  }
}

#stop instance

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on  = [terraform_data.catalogue]
}

# create AMI image

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue"
  source_instance_id = aws_instance.catalogue.id
  depends_on         = [aws_ec2_instance_state.catalogue]
}

#launch template

resource "aws_launch_template" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id

  # once autoscaling sees less traffic, it will terminate the instance
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  vpc_security_group_ids               = [local.catalogue_sg_id]

  # each time we apply terraform this version will be updated as default
  update_default_version = true

  # tags for instances created by launch template through autoscaling
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name = "${var.project}-${var.environment}-catalogue"
      },
      local.common_tags
    )
  }
  # tags for volumes created by instances
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      {
        Name = "${var.project}-${var.environment}-catalogue"
      },
      local.common_tags
    )
  }
  # tags for launch template
  tags = merge(
    {
      Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )
}

# Target Group
#Target group maintains health status of targets based on configured health checks.
resource "aws_lb_target_group" "catalogue" {
  name                 = "${var.project}-${var.environment}-catalogue"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = local.vpc_id
  deregistration_delay = 60

  health_check {
    healthy_threshold   = 2
    interval            = 10
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 3
  }
}

#Autoscaling group
resource "aws_autoscaling_group" "calalogue" {
  name="${var.project}-${var.environment}-catalogue"
  max_size = 10
  min_size = 1
  desired_capacity = 1

  launch_template {
    id=aws_launch_template.catalogue.id
    version = "$latest"
  }

  vpc_zone_identifier = [local.private_subnet_id]
  target_group_arns = [aws_lb_target_group.catalogue.arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    
    triggers = ["launch_template"]
  }
    # tags will be applied to instances created by ASG & ASG itself
  dynamic "tag" { 
    #for each accepts map/set ,below is a map after merging
    for_each = merge({Name="${var.project}-${var.environment}-catalogue"},local.common_tags) 

    content {
      key=tag.key
      value=tag.value
      propagate_at_launch = true
    }
  }
      # with in 15min autoscaling should be successful
  timeouts {
      delete = "15m"
  }
}

#ASG policy

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.calalogue.name
  name="${var.project}-${var.environment}-catalogue"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
            }

    target_value = 70.0
     }
}

# Listener rule 
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backendalb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

#delete instance

resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  depends_on = [aws_autoscaling_policy.catalogue] # need to delete after once last resource created
  
  # it executes in bastion
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id} "
  }
}