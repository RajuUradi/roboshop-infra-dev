output "vpc_id"{
    value=module.roboshop-vpc.vpc_id
}

output "public_subnet_id"{
    value=module.roboshop-vpc.public_subnet_ids
}


output "private_subnet_id"{
    value=module.roboshop-vpc.private_subnet_ids
}


output "database_subnet_id"{
    value=module.roboshop-vpc.database_subnet_ids
}