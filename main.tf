terraform {
  cloud {
    organization = "027-spring-cloud"

    workspaces {
      name = "my_first_workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {}

module "my_vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "172.15.0.0/16"
  tag = {
    Name = "modules_vpc"
  }
}

module "security" {
  source  = "app.terraform.io/02-spring-cloud/security/aws"
  version = "0.0.0"
  # insert required variables here
  vpc_id = module.my_vpc.my_vpc_id

  security_groups = {
    "web" = {
      "description" = "Security Group for Web Tier"
      "ingress_rules" = [
        {
          to_port = 0
          from_port = 0
          cidr_blocks = ["0.0.0.0/0"]
          protocol = "-1"
        },
        {
          to_port = 2
          from_port = 2
          cidr_blocks = ["0.0.0.0/0"]
          protocol = "tcp"
        }
      ]
    },
    "app" = {
      "description" = "xvyz"
      "egress_rule s" = [
        {
          to_port = 0
          from_port = 0
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      "ingress_rules" = [
        {
          to_port = 0 # 1
          from_port = 0 # 1
          protocol = "tcp" #3
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}



