resource "aws_vpc" "east_vpc" {
	cidr_block = var.east_vpc_cidr
	provider = aws.us_east_2
	tags = {
		Name = "East VPC"
	}
}

resource "aws_vpc" "west_vpc" {
        cidr_block = var.west_vpc_cidr
	provider = aws.us_west_2
        tags = {
                Name = "West VPC"
        }
}

resource "aws_vpc" "central_vpc" {
        cidr_block = var.central_vpc_cidr
	provider = aws.ca_central_1
        tags = {
                Name = "Central VPC"
        }
}

resource "aws_subnet" "east_vpc_subnets" {
	vpc_id = aws_vpc.east_vpc.id
	provider = aws.us_east_2
	for_each = var.east_vpc_subnet_cidrs
	cidr_block = each.value.cidr
	availability_zone = each.value.avail_zone
	tags = each.value.tags
	depends_on = [aws_vpc.east_vpc]
}

resource "aws_subnet" "west_vpc_subnets" {
        vpc_id = aws_vpc.west_vpc.id
        provider = aws.us_west_2
        for_each = var.west_vpc_subnet_cidrs
        cidr_block = each.value.cidr
        availability_zone = each.value.avail_zone
        tags = each.value.tags
	depends_on = [aws_vpc.west_vpc]
}

resource "aws_subnet" "central_vpc_subnets" {
        vpc_id = aws_vpc.central_vpc.id
        provider = aws.ca_central_1
        for_each = var.central_vpc_subnet_cidrs
        cidr_block = each.value.cidr
        availability_zone = each.value.avail_zone
        tags = each.value.tags
	depends_on = [aws_vpc.central_vpc]
}

