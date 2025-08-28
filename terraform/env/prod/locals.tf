locals {
  # 환경 설정 (하드코딩)
  environment = "prod"
  aws_region  = "ap-northeast-2"

  # 공통 태그
  common_tags = {
    Environment = local.environment
    Project     = "clokey"
    ManagedBy   = "terraform"
  }

  # 이름 규칙
  name_prefix = "${local.environment}-clokey"

  # 가용영역
  availability_zones = {
    a = "ap-northeast-2a"
    c = "ap-northeast-2c"
  }

  # CIDR 블록 (하드코딩)
  vpc_cidr = "10.0.0.0/16"
  public_subnets = {
    a = "10.0.1.0/24"
    c = "10.0.2.0/24"
  }
  private_subnets = {
    a = "10.0.11.0/24"
    c = "10.0.12.0/24"
  }

  # Backend 설정 (하드코딩)
  state_bucket_name = "clokey-terraform-state-116541188992"
  state_key         = "prod/terraform.tfstate"
}

