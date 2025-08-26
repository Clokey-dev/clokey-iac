locals {
  # 공통 태그
  common_tags = {
    Environment = var.environment
    Project     = "clokey"
    ManagedBy   = "terraform"
  }

  # 이름 규칙
  name_prefix = "${var.environment}-clokey"

  # 가용영역
  availability_zones = {
    a = "ap-northeast-2a"
    c = "ap-northeast-2c"
  }

  # CIDR 블록
  vpc_cidr = var.vpc_cidr_block
  public_subnets = {
    a = "10.0.1.0/24"
    c = "10.0.2.0/24"
  }
  private_subnets = {
    a = "10.0.11.0/24"
    c = "10.0.12.0/24"
  }
}

