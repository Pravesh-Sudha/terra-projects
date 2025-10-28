variable "region_name" {
  type        = string
  default     = "us-east-1"
  description = "description"
}

variable "app_name" {
  type        = string
  default     = "terra-ansible-starter"
  description = "Name of the application"
}

locals {
  environments = {
    dev   = 2
    stage = 2
    prod  = 2
  }

  instances = flatten([
    for env, count in local.environments : [
      for i in range(count) : {
        name = "${env}-${i + 1}"
        env  = env
      }
    ]
  ])
}


data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

