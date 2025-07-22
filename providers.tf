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
}
