terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
		}
	}
}

provider "aws" {
	profile = var.profile
	region = "us-west-2"
	alias = "us_west_2"
}

provider "aws" {
	profile = var.profile
	region = "us-east-2"
	alias = "us_east_2"
}

provider "aws" {
	profile = var.profile
	region = "ca-central-1"
	alias = "ca_central_1"
}
