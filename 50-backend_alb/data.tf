data "aws_ssm_parameter" "backend-alb_sg_id" {
    name="/${var.project}/${var.environment}/backend-alb/sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids"{
     name="/${var.project}/${var.environment}/private-subnet-id"
}