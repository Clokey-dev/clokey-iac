aws_region         = "ap-northeast-2"
environment        = "prod"
vpc_cidr_block     = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "ap-northeast-2a"

# RDS 설정 (기본값 - 민감한 정보는 secret.tfvars에서 관리)
# rds_username은 secret.tfvars에서 관리

# User Data (기본값 - 민감한 정보는 secret.tfvars에서 관리)
# userdata는 locals.tf에서 filebase64() 함수로 로드됨
