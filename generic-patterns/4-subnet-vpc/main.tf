resource "aws_vpc" "vpc" {
	cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnets" {
	for_each = var.vpc_subnets

	vpc_id = aws_vpc.vpc.id
	availability_zone = each.value.availability_zone
	cidr_block = each.value.cidr
	tags = each.value.tags
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.vpc.id
	depends_on = [aws_vpc.vpc]
}

resource "aws_eip" "nat_eip" {
	domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
	allocation_id = aws_eip.nat_eip.id
	subnet_id = aws_subnet.subnets["public_subnet_1"].id 
}

resource "aws_route_table" "public_to_internet" {
	vpc_id = aws_vpc.vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}	
}

resource "aws_route_table_association" "route_table_association" {
	for_each = toset(data.aws_subnets.public_subnet_ids.ids)

	subnet_id = each.value
	route_table_id = aws_route_table.public_to_internet.id
}

resource "aws_default_route_table" "default_vpc_route_table" {
	default_route_table_id = aws_vpc.vpc.default_route_table_id
        route {
                cidr_block = "10.0.0.0/16"
                gateway_id = "local"
        }
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_nat_gateway.nat.id
        }
}
