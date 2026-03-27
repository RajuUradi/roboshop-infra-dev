resource "aws_lb" "backend-alb" {
  name               = "${var.project}-${var.environment}-backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend-alb_sg_id]
  subnets            = [local.private_subnet_ids]

 # keeping it as false, just to delete using terraform while practice
  enable_deletion_protection = false
  tags = merge(
    {Name="${var.project}-${var.environment}-backend-alb"} , local.common_tags
  )

}


#alb listener 

resource "aws_lb_listener" "backend-alb" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Iam Backend ALB "
      status_code  = "200"
    }
  }
}

#Route53 record for backend-alb
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.dns_name}"           # *.backend-alb-dev.learnawsdevops.online
  type    = "A"

  alias {
    name                   = aws_elb.backend-albalb.dns_name
    zone_id                = aws_elb.backend-alb.zone_id
    evaluate_target_health = true  
  }
}
