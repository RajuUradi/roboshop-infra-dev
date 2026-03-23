resource "aws_ssm_parameter" "sgid" {
    for_each =toset(var.sgnames)
    name="/${var.project}/${var.environment}/${each.value}/sg_id"
    type= "String"
    value = module.sg[each.value].sg_id
  
}