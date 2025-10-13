locals {
  # 환경 설정
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

  # Backend 설정 (하드코딩)
  state_bucket_name = "clokey-terraform-state-116541188992"
  state_key         = "prod/terraform.tfstate"

  # UserData 설정 (파일에서 base64로 인코딩하여 로드)
  user_data_base64 = filebase64("${path.module}/../../../userdata-examples/was-userdata.sh")
}

