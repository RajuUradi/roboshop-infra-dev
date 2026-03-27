locals{
    ami_id=data.aws_ami.devops.id
    catalogue_sg_id=data.aws_ssm_parameter.catalogue_sg_id.value
    private_subnet_id=split("," , data.aws_ssm_parameter.private_subnet_id.value)[0]
    vpc_id=data.aws_ssm_parameter.vpc_id.value
    backendalb_listener_arn=data.aws_ssm_parameter.backend-alb-listener-arn.value
    common_tags={
        Project ="Roboshop"
        Environment="dev"
        Terraform="True"
    }
}