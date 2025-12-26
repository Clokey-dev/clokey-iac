# 민감한 정보만 변수화 (CI/CD에서 관리)
variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

variable "rds_username" {
  description = "Username for RDS database"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "Password for RDS database"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for the application (from GitHub Secrets)"
  type        = string
  sensitive   = true
}

variable "email" {
  description = "Email address for Let's Encrypt certificate (from GitHub Secrets)"
  type        = string
  sensitive   = true
  default     = "aa020228@gmail.com"
}

