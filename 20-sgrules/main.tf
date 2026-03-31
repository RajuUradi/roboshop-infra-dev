#You cannot use "" for ports.(ex : from port="22") from_port and to_port must be numeric values like 5672, not strings.
#“Ports in Terraform security groups must be integers because AWS APIs expect numeric values.”
resource "aws_security_group_rule" "bastion_internet"{
    type="ingress"
    from_port=22
    to_port = 22
    protocol  = "tcp"
    #source
     cidr_blocks = ["0.0.0.0/0"] 
    #cidr_blocks=[data.http.my_public_ip_v4]
    # which SG you are creating this rule
    security_group_id = data.aws_ssm_parameter.bastion_sg_id.value
}

#lets configure Mongodb SG rules

#bastion --> mongoDB
#catalogue ---> mongodb
#user ----> mongodb


resource "aws_security_group_rule" "mongodb_bastion" {
    type="ingress"
    from_port= 22
    to_port=22
    protocol  = "tcp"
    source_security_group_id=data.aws_ssm_parameter.bastion_sg_id.value
    security_group_id=data.aws_ssm_parameter.mongodb_sg_id.value
  
}

resource "aws_security_group_rule" "mongodb_catalogue"{
    type="ingress"
    from_port=27017
    to_port=27017
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.catalogue_sg_id.value
    security_group_id = data.aws_ssm_parameter.mongodb_sg_id.value
}

resource "aws_security_group_rule" "mongodb_user"{
    type="ingress"
    from_port=27017
    to_port=27017
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.user_sg_id.value
    security_group_id = data.aws_ssm_parameter.mongodb_sg_id.value
}

# redis

# bastion ---> redis
# user    ---> redis
# cart    ---> redis

resource "aws_security_group_rule" "redis_bastion" {
    type = "ingress"
    from_port=22
    to_port=22
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.bastion_sg_id.value
    security_group_id=data.aws_ssm_parameter.redis_sg_id.value

}

resource "aws_security_group_rule" "redis_user"{
    type="ingress"
    from_port=6379
    to_port=6379
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.user_sg_id.value
    security_group_id = data.aws_ssm_parameter.redis_sg_id.value
}

resource "aws_security_group_rule" "redis_cart" {
  type="ingress"
  from_port=6379
  to_port=6379
  protocol = "tcp"
  source_security_group_id=data.aws_ssm_parameter.cart_sg_id.value
  security_group_id = data.aws_ssm_parameter.redis_sg_id.value
}


#mysq
#bastion --> mysql
#shipping -->mysql

resource "aws_security_group_rule" "mysql_bastion" {
    type="ingress"
    from_port=22
    to_port=22
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.bastion_sg_id.value
    security_group_id = data.aws_ssm_parameter.mysql_sg_id.value
  
}

resource "aws_security_group_rule" "mysql_shipping"{
    type="ingress"
    from_port=3306
    to_port=3306
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.shipping_sg_id.value
    security_group_id = data.aws_ssm_parameter.mysql_sg_id.value

}

#rabbitmq
#bastion-->rabbitmq
#payment-->rabbitmq

resource "aws_security_group_rule" "rabbitmq_bastion" {
    type="ingress"
    from_port=22
    to_port=22
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.bastion_sg_id.value
    security_group_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
  
}

resource "aws_security_group_rule" "rabbitmq_payment"{
    type="ingress"
    from_port=5672
    to_port=5672
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.payment_sg_id.value
    security_group_id = data.aws_ssm_parameter.rabbitmq_sg_id.value

}

# backend-ALB

# bastion----> backendalb
#bastion ----> calalogue
#backendalb---->catalogue

resource "aws_security_group_rule" "backendalb_bastion"{
    type ="ingress"
    from_port=80
    to_port=80
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.bastion_sg_id.value
    security_group_id=data.aws_ssm_parameter.backendalb_sg_id.value

}

resource "aws_security_group_rule" "catalogue_bastion"{
    type ="ingress"
    from_port=22
    to_port=22
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.bastion_sg_id.value
    security_group_id=data.aws_ssm_parameter.catalogue_sg_id.value
}

resource "aws_security_group_rule" "catalogue_backendalb"{
    type ="ingress"
    from_port=8080
    to_port=8080
    protocol = "tcp"
    source_security_group_id=data.aws_ssm_parameter.backendalb_sg_id.value
    security_group_id=data.aws_ssm_parameter.catalogue_sg_id.value
}


