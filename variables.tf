variable "vpc_cidr" {
	type = string
	default = "10.0.0.0/24"
}

variable "public_cidr" {
	type = string
	default = "10.0.0.0/25"
}

variable "private_cidr" {
	type = string
	default = "10.0.0.128/25"
}

data "aws_iam_instance_profile" "SSM" {
	name = "SSMRoleforManagedHosts"
}

variable "profile" {
	type = string
}

variable "home_ip" {
	type = string
}

data "aws_ami" "amazon_linux" {
	most_recent = true
	owners = ["amazon"]
	filter {
		name = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}
}
