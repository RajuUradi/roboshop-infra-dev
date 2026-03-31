data "aws_ssm_parameter" "frontend-alb_sg_id"{
    name="/${var.project}/${var.environment}/frontent-alb/sg_id"
}

data "aws_ssm_parameter" "public_subnet_id"{
    name="/${var.project}/${var.environment}/public-subnet-id"
}

data "aws_ssm_parameter" "acm_cert_arn"{
    name="/${var.project}/${var.environment}/acm_cert_arn"
}