variable "region" {
        type = string
        default = "us-east-1"
}

variable "vpc_cidr" {
        type = string
        default = "10.0.0.0/16"
}

variable "management_cidr" {
        type = string
        default = "10.0.0.0/24"
}

variable "inside_cidr" {
        type = string
        default = "10.0.1.0/24"
}

variable "outside_cidr" {
        type = string
        default = "10.0.2.0/24"
}
