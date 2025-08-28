variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "rds_username" {
  description = "Username for RDS database"
  type        = string
  sensitive   = true
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

# Backend Configuration Variables
variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "clokey-terraform-state-116541188992"
}

variable "state_key" {
  description = "S3 key for Terraform state"
  type        = string
  default     = "dev/terraform.tfstate"
}

# AWS Account ID (GitHub Secrets에서 주입)
variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  sensitive   = true
}

variable "user_data" {
  description = "Custom user data script for EC2 instances"
  type        = string
  default     = null
  sensitive   = true
}
