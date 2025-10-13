aws_region         = "ap-northeast-2"
environment        = "dev"
vpc_cidr_block     = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "ap-northeast-2a"

# RDS 설정 (기본값 - 민감한 정보는 secret.tfvars에서 관리)
# rds_username은 secret.tfvars에서 관리

# Route53 설정 (기본값 - 민감한 정보는 secret.tfvars에서 관리)
# domain_name은 secret.tfvars에서 관리

# User Data (기본값 - 민감한 정보는 secret.tfvars에서 관리)
# filebase64()를 사용하여 파일을 base64로 인코딩하여 전달
user_data = filebase64("../../../userdata-examples/was-userdata.sh")
