resource "aws_ssm_parameter" "vpcid"{
    name="/${var.project}/${var.environment}/vpc_id"
     type  = "String"
     value=module.roboshop-vpc.vpc_id
}

resource "aws_ssm_parameter" "public-subnet-id"{
    name="/${var.project}/${var.environment}/public-subnet-id"
    type="StringList"
    value= join(",",module.roboshop-vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private-subnet-id"{
    name="/${var.project}/${var.environment}/private-subnet-id"
    type="StringList"
    value= join(",",module.roboshop-vpc.private_subnet_ids)

}

resource "aws_ssm_parameter" "database-subnet-id"{
    name="/${var.project}/${var.environment}/database-subnet-id"
    type="StringList"
    value= join(",",module.roboshop-vpc.database_subnet_ids)

}