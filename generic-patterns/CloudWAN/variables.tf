variable "profile" {
	type = string
	default = "isrlabs-general"
}

variable "east_vpc_cidr" {
	type = string
	default = "10.0.0.0/16"
}

variable "west_vpc_cidr" {
	type = string
	default = "10.1.0.0/16"
}

variable "central_vpc_cidr" {
	type = string
	default = "10.2.0.0/16"
}

variable "east_vpc_subnet_cidrs" {
	type = map(object({
		avail_zone = string
		cidr = string
		tags = map(string)
	}))
	default = {
		public-1a = {
			avail_zone = "us-east-2a"
			cidr = "10.0.1.0/24"
			tags = {
				Name = "Public 1A"
			}
		},
		public-2b = {
			avail_zone = "us-east-2b"
			cidr = "10.0.2.0/24"
			tags = {
				Name = "Public 2B"
			}
		},
		public-3c = {
			avail_zone = "us-east-2c"
			cidr = "10.0.3.0/24"
			tags = {
				Name = "Public 3C"
			}
		}
                transit-1a = {
                        avail_zone = "us-east-2a"
                        cidr = "10.0.100.0/24"
                        tags = {
                                Name = "Transit 1A"
                        }
                },
                transit-2b = {
                        avail_zone = "us-east-2b"
                        cidr = "10.0.101.0/24"
                        tags = {
                                Name = "Transit 2B"
                        }
                },
                transit-3c = {
                        avail_zone = "us-east-2c"
                        cidr = "10.0.102.0/24"
                        tags = {
                                Name = "Transit 3C"
                        }
                }


	}
}

variable "west_vpc_subnet_cidrs" {
        type = map(object({
                avail_zone = string
                cidr = string
                tags = map(string)
        }))
        default = {
                public-1a = {
                        avail_zone = "us-west-2a"
                        cidr = "10.1.1.0/24"
                        tags = {
                                Name = "Public 1A"
                        }
                },
                public-2b = {
                        avail_zone = "us-west-2b"
                        cidr = "10.1.2.0/24"
                        tags = {
                                Name = "Public 2B"
                        }
                },
                public-3c = {
                        avail_zone = "us-west-2c"
                        cidr = "10.1.3.0/24"
                        tags = {
                                Name = "Public 3C"
                        }
                }
                transit-1a = {
                        avail_zone = "us-west-2a"
                        cidr = "10.1.100.0/24"
                        tags = {
                                Name = "Transit 1A"
                        }
                },
                transit-2b = {
                        avail_zone = "us-west-2b"
                        cidr = "10.1.101.0/24"
                        tags = {
                                Name = "Transit 2B"
                        }
                },
                transit-3c = {
                        avail_zone = "us-west-2c"
                        cidr = "10.1.102.0/24"
                        tags = {
                                Name = "Transit 3C"
                        }
                }


        }
}

variable "central_vpc_subnet_cidrs" {
        type = map(object({
                avail_zone = string
                cidr = string
                tags = map(string)
        }))
        default = {
                public-1a = {
                        avail_zone = "ca-central-1a"
                        cidr = "10.2.1.0/24"
                        tags = {
                                Name = "Public 1A"
                        }
                },
                public-2b = {
                        avail_zone = "ca-central-1b"
                        cidr = "10.2.2.0/24"
                        tags = {
                                Name = "Public 2B"
                        }
                },
                public-3c = {
                        avail_zone = "ca-central-1d"
                        cidr = "10.2.3.0/24"
                        tags = {
                                Name = "Public 3C"
                        }
                }
                transit-1a = {
                        avail_zone = "ca-central-1a"
                        cidr = "10.2.100.0/24"
                        tags = {
                                Name = "Transit 1A"
                        }
                },
                transit-2b = {
                        avail_zone = "ca-central-1b"
                        cidr = "10.2.101.0/24"
                        tags = {
                                Name = "Transit 2B"
                        }
                },
                transit-3c = {
                        avail_zone = "ca-central-1d"
                        cidr = "10.2.102.0/24"
                        tags = {
                                Name = "Transit 3C"
                        }
                }


        }
}

