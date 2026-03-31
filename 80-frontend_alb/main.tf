resource "aws_lb" "frontend-alb" {
  name="${var.project}-${var.environment}-frontend-alb"
  internal=false
  load_balancer_type = "application"
  security_groups    = [local.frontend-alb_sg_id]
  subnets=local.public_subnet_id
  
   # keeping it as false, just to delete using terraform while practice
  enable_deletion_protection = false

  tags = merge(
    {
        Name = "${var.project}-${var.environment}-frontend"
    },
    local.common_tags
  )


}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.frontend-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.acm_cert_arn
  alpn_policy       = "HTTP2Preferred"

  default_action{
    type="fixed-response"

    fixed_response{
    content_type = "text/plain"
     message_body="iam frontend_alb"
     status_code = "200"
    }
  }
}

resource "aws_route_53_record" "fronttend_alb_record"{
    zone_id=var.zone_id
    record="frontend-alb.${var.dns_name}"
    type    = "A"

      # load balancer details
    alias {
        name=aws_lb.frontend-alb.name
         zone_id    = aws_lb.frontend_alb.zone_id
         evaluate_target_health = true
    }
  allow_overwrite=true
}