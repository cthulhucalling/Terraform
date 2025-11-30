variable "profile" {
	type = string
	default = "isrlabs-general"
}

variable "vpc_cidr" {
	type = string
	default = "10.0.0.0/16"
}

data "aws_subnets" "public_subnet_ids" {
	filter {
		name = "vpc-id"
		values = [aws_vpc.vpc.id]
	}

	tags = {
		Environment = "public"
	}
}

variable "vpc_subnets" {
	type = map(object({
		availability_zone = string
		cidr = string
		tags = map(string)
	}))
	default = {
		public_subnet_1 = {
			availability_zone = "us-west-2a"
			cidr = "10.0.1.0/24"
			tags = {
				Name = "public_subnet_1"
				Environment = "public"
			}
		},
		private_subnet_1 = {
			availability_zone = "us-west-2a"
			cidr = "10.0.2.0/24"
			tags = {
				Name = "private_subnet_1"
				Environment = "private"
			}
		},
		public_subnet_2 = {
			availability_zone = "us-west-2b"
			cidr = "10.0.3.0/24"
			tags = {
				Name = "public_subnet_2"
				Environment = "public"
			}
		},
		private_subnet_2 = {
			availability_zone = "us-west-2b"
			cidr = "10.0.4.0/24"
			tags = {
				Name = "private_subnet_2"
				Environment = "pricate"
			}
		}
	}
}

