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

variable "availability_zone" {
  type = string
}

variable "rds_username" {
  type      = string
  sensitive = true
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for domain"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Base domain name for Route53 records"
  type        = string
  default     = "example.com"
  sensitive   = true
}
