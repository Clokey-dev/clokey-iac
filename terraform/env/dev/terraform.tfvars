aws_region            = "ap-northeast-2"
environment           = "dev"
vpc_cidr_block        = "10.0.0.0/16"
public_subnet_cidr    = "10.0.1.0/24"
availability_zone     = "ap-northeast-2a"

# RDS 설정
rds_username = "admin"

# Route53 설정
domain_name = "clokey.store"  # 새로운 도메인 생성
