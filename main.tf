resource "aws_security_group" "default" {
  for_each    = var.security_groups
  name        = each.key
  description = each.value.description
  vpc_id      = var.vpc_id
 
  dynamic "ingress" {
    for_each = length(each.value.ingress_rules) > 0 ? each.value.ingress_rules : []
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : []
      security_groups = length(ingress.value.security_groups) > 0 ? ingress.value.security_groups : []
    }
  }
  
  dynamic "egress" {
    for_each = length(each.value.egress_rules) > 0 ? each.value.egress_rules : []
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : []
      security_groups = length(egress.value.security_groups) > 0 ? egress.value.security_groups : []
    }
  }
 
  tags = {
    Name = join("-", ["security-group", each.key])
  }
}
 
variable "vpc_id" {
  type = string
  description = "The ID of the VPC where the security group will be created."
}
 
variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      from_port   = number
      to_port     = number
      description = optional(string)
      cidr_blocks = optional(list(string))
      security_groups = optional(list(string))
      protocol    = string
    })))
    egress_rules = optional(list(object({
      from_port   = number
      to_port     = number
      description = optional(string)
      cidr_blocks = optional(list(string))
      security_groups = optional(list(string))
      protocol    = string
    })))
  }))
  default = {}
}

output "security_group_ids" {
  value = {for k, v in aws_security_group.default : k => v.id}
}
