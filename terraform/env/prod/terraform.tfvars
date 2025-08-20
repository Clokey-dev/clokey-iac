aws_region            = "ap-northeast-2"
environment           = "prod"
vpc_cidr_block        = "10.0.0.0/16"
public_subnet_cidr    = "10.0.1.0/24"
availability_zone     = "ap-northeast-2a"

# RDS 설정
rds_username = "admin"

# Route53 설정
hosted_zone_id = "Z1234567890ABC"  # clokey.store 도메인의 hosted zone ID (실제 값으로 변경)
domain_name = "clokey.store"  # 실제 도메인
