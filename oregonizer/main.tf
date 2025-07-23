resource "aws_vpc" "main" {
	cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_cidr" {
	vpc_id = aws_vpc.main.id
	cidr_block = var.public_cidr
	map_public_ip_on_launch = true
	availability_zone = "us-west-2a"
	depends_on = [aws_vpc.main]
}

resource "aws_subnet" "private_cidr" {
	vpc_id = aws_vpc.main.id
	cidr_block = var.private_cidr
	map_public_ip_on_launch = false
	availability_zone = "us-west-2b"
	depends_on = [aws_vpc.main]
}

resource "aws_internet_gateway" "ig" {
	vpc_id = aws_vpc.main.id
	depends_on = [aws_vpc.main]
}

resource "aws_default_route_table" "vpc_route_table" {
		default_route_table_id = aws_vpc.main.default_route_table_id
		route {
			cidr_block = "10.0.0.0/24"
			gateway_id = "local"
		}
		
		route {
			cidr_block = "0.0.0.0/0"
			gateway_id = aws_internet_gateway.ig.id
		}
}

resource "aws_security_group" "allow_home" {
	vpc_id = aws_vpc.main.id
	name = "allow home"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_home" {
	security_group_id = aws_security_group.allow_home.id
	cidr_ipv4 = var.home_ip
	from_port = 0
	to_port = 22
	ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_proxy_from_home" {
	security_group_id = aws_security_group.allow_home.id
	cidr_ipv4 = var.home_ip
	from_port = 0
	to_port = 23
	ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
	security_group_id = aws_security_group.allow_home.id
	cidr_ipv4 = "0.0.0.0/0"
	ip_protocol = "-1"	
}

resource "aws_instance" "my_proxy" {
	ami = data.aws_ami.amazon_linux.id
	instance_type = "t3.micro"
	subnet_id = aws_subnet.public_cidr.id
	vpc_security_group_ids = [aws_security_group.allow_home.id]
	depends_on = [aws_internet_gateway.ig]
	user_data = templatefile("${path.module}/bootstrap.sh",{home_ip=var.home_ip})
	key_name = "<sshkey>"
}
