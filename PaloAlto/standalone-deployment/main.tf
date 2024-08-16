#This module seems to have problems with optional stuff being non-optional
#The examples and documentation PA has on the TF registry is bad and has typos
#I hope they do better sometime soon...

#Anyway... this will be your classic 3-interface setup
#and will build a VPC with 3 subnets, one inside, one outside and a management interface
#management will have a security group that will allow only the authorized IPs to access it on ports 22 and 443

resource "aws_vpc" "firewall_vpc" {
        cidr_block = var.vpc_cidr
}

resource "aws_subnet" "management_subnet" {
        vpc_id = aws_vpc.firewall_vpc.id
        cidr_block = var.management_cidr
        availability_zone = "us-east-1a"
        map_public_ip_on_launch = true
}

resource "aws_subnet" "inside_subnet" {
        vpc_id = aws_vpc.firewall_vpc.id
        cidr_block = var.inside_cidr
        availability_zone = "us-east-1a"
}

resource "aws_subnet" "outside_subnet" {
        vpc_id = aws_vpc.firewall_vpc.id
        cidr_block = var.outside_cidr
        availability_zone = "us-east-1a"
        map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "firewall_vpc_ig" {
        vpc_id = aws_vpc.firewall_vpc.id
}

resource "aws_security_group" "allow_access_from_home" {
        vpc_id = aws_vpc.firewall_vpc.id
        name = "Allow home IP"
        ingress {
                from_port = "22"
                to_port = "22"
                protocol = "tcp"
                cidr_blocks = ["xxx.xxx.xxx.xxx/32"]
        }

        ingress {
                from_port = "443"
                to_port = "443"
                protocol = "tcp"
                cidr_blocks = ["xxx.xxx.xxx.xxx/32"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = -1
                cidr_blocks = ["0.0.0.0/0"]
        }
}

### Let's try to make a Palo Alto!
module "vmseries-modules_vmseries" {
        source  = "PaloAltoNetworks/vmseries-modules/aws//modules/vmseries"
        version = "1.1.6"

        name = "Palo Alto Firewall"
        #this seems completely useless since the module still complains about a lack of ami-id
        #the documentation says if you specify a version, it will look for that in AWS Marketplace
        #but it doesn't
        vmseries_version = "10.2.0"
        #TF complaining about lack of ami-id for some reason
        vmseries_ami_id = "ami-12345"
        ssh_key_name = "mysshkeypair"
        interfaces = {
                mgmt = {
                        device_index = 0
                        name = "Management"
                        subnet_id = aws_subnet.management_subnet.id
                        create_public_ip = true
                        security_group_ids=[aws_security_group.allow_access_from_home.id]
                },
                public = {
                        device_index = 1
                        name = "Outside"
                        subnet_id = aws_subnet.outside_subnet.id
                        create_public_ip = true
                        security_group_ids = []
                },
                private = {
                        device_index = 2
                        name = "Inside"
                        subnet_id = aws_subnet.inside_subnet.id
                        create_public_ip = false
                        security_group_ids = []
                }
        }
}
