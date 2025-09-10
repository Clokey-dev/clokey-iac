# AWS 인증 정보는 환경변수(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)로 자동 처리됨

# 민감한 정보만 변수화 (CI/CD에서 관리)
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
