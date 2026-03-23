module sg {
    for_each = toset(var.sgnames)
    source="git::https://github.com/RajuUradi/terraform-aws-sg.git?ref=main"
    project=var.project
    environment=var.environment
    sgname=each.value
    vpcid=data.aws_ssm_parameter.vpcid.value

}