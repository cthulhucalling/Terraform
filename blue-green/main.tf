resource "aws_vpc" "main" {
        cidr_block = var.vpc_cidr
}

resource "aws_subnet" "green_subnet" {
        vpc_id = aws_vpc.main.id
        cidr_block = var.green_subnet
        map_public_ip_on_launch = false
        availability_zone = "us-east-1b"
}

resource "aws_subnet" "blue_subnet" {
        vpc_id = aws_vpc.main.id
        cidr_block = var.blue_subnet
        map_public_ip_on_launch = false
        availability_zone = "us-east-1c"
}

resource "aws_subnet" "public_subnet1" {
        vpc_id = aws_vpc.main.id
        cidr_block = var.public_subnet1
        map_public_ip_on_launch = true
        availability_zone = "us-east-1b"
}

resource "aws_subnet" "public_subnet2" {
        vpc_id = aws_vpc.main.id
        cidr_block = var.public_subnet2
        map_public_ip_on_launch = true
        availability_zone = "us-east-1c"
}

resource "aws_route_table" "public_to_internet" {
        vpc_id = aws_vpc.main.id
        route {
                cidr_block = "10.1.0.0/16"
                gateway_id = "local"
        }
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.vpc-ig.id
        }
}

resource "aws_default_route_table" "vpc_route_table" {
        default_route_table_id = aws_vpc.main.default_route_table_id
        route {
                cidr_block = "10.1.0.0/16"
                gateway_id = "local"
        }
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_nat_gateway.nat_gateway.id
        }
}

resource "aws_route_table_association" "public1" {
        subnet_id = aws_subnet.public_subnet1.id
        route_table_id = aws_route_table.public_to_internet.id
}

resource "aws_route_table_association" "public2" {
        subnet_id = aws_subnet.public_subnet2.id
        route_table_id = aws_route_table.public_to_internet.id
}

resource "aws_internet_gateway" "vpc-ig" {
        vpc_id = aws_vpc.main.id

}

resource "aws_eip" "nat_eip" {
        domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
        allocation_id = aws_eip.nat_eip.id
        subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_security_group" "allow-home-port-80" {
        vpc_id = aws_vpc.main.id
        name = "Allow home IP"
        ingress {
                from_port = "80"
                to_port = "80"
                protocol = "tcp"
                cidr_blocks = ["38.141.49.254/32"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
}

resource "aws_security_group" "allow-internal-network" {
        vpc_id = aws_vpc.main.id
        name = "Allow internal network"
        ingress {
                from_port = "80"
                to_port = "80"
                protocol = "tcp"
                cidr_blocks = [aws_vpc.main.cidr_block]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
}

resource "aws_lb" "app" {
        internal = false
        load_balancer_type = "application"
        subnets = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
        security_groups = [aws_security_group.allow-home-port-80.id]
}

resource "aws_lb_listener" "app" {
        load_balancer_arn = aws_lb.app.arn
        port = "80"
        protocol = "HTTP"
        default_action {
                type = "forward"
                forward {
                        target_group {
                                arn = aws_lb_target_group.blue.arn
                                weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
                        }

                        target_group {
                                arn = aws_lb_target_group.green.arn
                                weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
                        }
                        stickiness {
                                enabled = false
                                duration = 1
                        }
                }
        }
}
