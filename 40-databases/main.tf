#mongodb
resource "aws_instance" "mongodb"{
    ami=local.ami_id
    instance_type="t3.micro"
    subnet_id = local.database_subnet_id
    vpc_security_group_ids = [local.mongodb_sg_id]
    tags=merge(local.common_tags ,{Name="${var.project}-${var.environment}-mongodb"})
}

resource "terraform_data" "mongodb" {
    triggers_replace=aws_instance.mongodb.id
  
  connection {  # to connect mongodb
    type="ssh"
    user="ec2-user"
    password = "DevOps321"
    host=aws_instance.mongodb.private_ip
  }

#provisioner file block Copies files or directories from the machine where Terraform is running to the new resource .
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec"{
   inline=[
    "chmod +x /tmp/bootstrap.sh" ,
    "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
   ]
  }

}

#redis
resource "aws_instance" "redis" {
  ami=data.aws_ami.roboshop.id
  instance_type="t3.micro"
  subnet_id=local.database_subnet_id
  vpc_security_group_ids=[local.redis_sg_id]
  tags=merge(local.common_tags ,{Name="${var.project}-${var.environment}-redis"})

}

resource "terraform_data" "redis"{
    triggers_replace= aws_instance.redis.id

    connection {
        type="ssh"
        user="ec2-user"
        password = "DevOps321"
        host=aws_instance.redis.private_ip
    }

    provisioner "file" {
        source="bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec"{
        inline=[
           " chmod +x /tmp/bootstrap.sh " ,
           " sudo sh /tmp/bootstrap.sh redis ${var.environment}"

            ]
    }
}

#rabbitmq
resource "aws_instance" "rabbitmq"{
  ami=local.ami_id
  instance_type="t3.micro"
  subnet_id=local.database_subnet_id
  vpc_security_group_ids=[local.rabbitmq_sg_id]

  tags=merge(local.common_tags,{Name="${var.project}-${var.environment}-rabbitmq"})
}

resource "terraform_data" "rabbitmq"{
  triggers_replace = aws_instance.rabbitmq

  connection{
    type="ssh"
    user="ec2-user"
    password="DevOps321"
    host= aws_instance.rabbitmq.private_ip
  }

  provisioner "file"{
    source="bootstrap.sh"
    destination="/tmp/bootstrap.sh"
  }

  provisioner "remote-exec"{
    inline=[
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
}

#mysql

resource "aws_instance" "mysql" {
  ami=local.ami_id
  instance_type = "t3.micro"
  subnet_id=local.database_subnet_id
  vpc_security_group_ids=[local.mysql_sg_id]
  iam_instance_profile = aws_iam_instance_profile.mysql.name
  tags=merge(local.common_tags,{Name="${var.project}-${var.environment}-mysql"})
}

resource "terraform_data" "mysql"{
  triggers_replace=aws_instance.mysql.id

  connection{
    type="ssh"
    user="ec2-user"
    password="DevOps321"
    host=aws_instance.mysql.private_ip
  }

  provisioner "file" {
    source="bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec"{
    inline=[
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment} "
      ]
  }
}