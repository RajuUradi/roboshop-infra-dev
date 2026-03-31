resource "aws_ssm_parameter" "acm_cert" {
  name="/${var.project}/${var.environment}/acm_cert_arn"
   type  = "String"
  value = aws_acm_certificate.roboshop.arn
}