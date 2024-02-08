variable "vpc_cidr" {
        type = string
        default = "10.1.0.0/16"
}

variable "public_subnet1" {
        type = string
        default = "10.1.0.0/24"
}

variable "public_subnet2" {
        type = string
        default = "10.1.3.0/24"
}

variable "blue_subnet" {
        type = string
        default = "10.1.1.0/24"
}

variable "green_subnet" {
        type = string
        default = "10.1.2.0/24"
}

variable "blue_instance_count" {
        type = number
        default = 2
}

variable "green_instance_count" {
        type = number
        default = 2
}

variable "blue_enable" {
        type = bool
        default = true
}

variable "green_enable" {
        type = bool
        default = true
}

data "aws_ami" "amazon_linux" {
        most_recent = true
        owners = ["amazon"]

        filter {
                name   = "name"
                values = ["amzn2-ami-hvm-*-x86_64-gp2"]
        }
}

locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}

data "aws_iam_instance_profile" "SSM" {
        name = "SSMRoleforManagedHosts"
}
