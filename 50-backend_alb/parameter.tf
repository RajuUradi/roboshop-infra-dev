resource "aws_ssm_parameter" "backend-alb-listener-arn"{
    name="${var.project}-${var.environment}-backend-alb"
    type="String"
    value=aws_lb_listener.backend-alb.arn
}