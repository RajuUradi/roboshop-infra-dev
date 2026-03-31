locals{
    frontend-alb_sg_id=data.aws_ssm_parameter.frontend-alb_sg_id.value
    public_subnet_id=split("," ,data.aws_ssm_parameter.public_subnet_id.value)
    acm_cert_arn=data.aws_ssm_parameter.acm_cert_arn.value
    common_tags={
        Name="roboshop-frontendalb"
        project="roboshop"
        Environment="true"
    }
}