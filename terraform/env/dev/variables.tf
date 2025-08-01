variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "availability_zone"   {
  type = string
}

variable "ami" {
  type = string
}

variable "rds_username" {
  type      = string
  sensitive = true
}
