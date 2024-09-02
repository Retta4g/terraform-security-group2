resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = var.tag
}

variable "vpc_cidr_block" {}
variable "tag" {}

output "my_vpc_id" {
  value = aws_vpc.my_vpc.id
}
# modules/security/outputs.tf

output "web_security_group_id" {
  value = aws_security_group.default["web"].id
}
 #
 