aws_region         = "ap-northeast-2"
environment        = "dev"
vpc_cidr_block     = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "ap-northeast-2a"

# RDS 설정 (기본값)
rds_username = "admin"

# Route53 설정 (기본값)
domain_name = "dev.clokey.store"

# User Data 기본값 (필요시 CI에서 오버라이드)
user_data = null
