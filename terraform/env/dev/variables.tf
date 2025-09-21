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

variable "user_data" {
  description = "Custom user data script for EC2 instances"
  type        = string
  default     = null
  sensitive   = true
}

# Route53 설정 (도메인 관련)
variable "domain_name" {
  description = "Base domain name for Route53 records"
  type        = string
  default     = "example.com"
  sensitive   = true
}
