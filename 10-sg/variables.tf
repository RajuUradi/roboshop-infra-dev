variable "project" {
    default="roboshop"
}

variable "environment" {
    default="dev"
}

variable "sgnames"{
    default = [
        #databases
        "mongodb" ,"redis" ,"mysql" ,"rabbitmq" ,
        #backend
        "catalogue","user","cart","shipping","payment",
        #frontend
        "frontend",
        #backend alb
        "backend-alb" ,
        #frontent-alb
        "frontent-alb",
        #bastion
        "bastion"]
}

