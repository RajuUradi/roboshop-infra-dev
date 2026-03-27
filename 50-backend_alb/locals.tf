locals{
    backend-alb_sg_id=data.aws_ssm_parameter.backend-alb_sg_id.value
    private_subnet_ids=data.aws_ssm_parameter.private_subnet_ids.value

    common_tags={
        Project="roboshop"
        Environment="Dev"
        Terraform="true"
    }
}