data "aws_ami" "devops" {
    most_recent= true
    owners=["973714476881"]

    filter {
        name="name"
        values=["Redhat-9-DevOps-Practice"]
    }

    filter{
        name="root-device-type"
        values=["ebs"]
    }
}

data "aws_ssm_parameter" "catalogue_sg_id"{
    name="/${var.project}/${var.environment}/catalogue/sg_id"
}

data "aws_ssm_parameter" "private_subnet_id"{
     name="/${var.project}/${var.environment}/private-subnet-id"
}

data "aws_ssm_parameter" "vpc_id"{
    name="/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "backend-alb-listener-arn"{
    name="${var.project}-${var.environment}-backend-alb"
}