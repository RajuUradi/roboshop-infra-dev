variable "project" {
    default="roboshop"
}

variable "environment"{
    default="dev"
}

variable "zone_id" {   # route53 record "learnawsdevops.online" Hosted Zone-id
  default="Z089384324SSER33VQP60"
}

variable "dns_name" {  
  default="learnawsdevops.online"
}