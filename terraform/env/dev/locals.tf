locals {
  # 환경 설정
  environment = "dev"
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
  state_key         = "dev/terraform.tfstate"

  # UserData 설정 (템플릿 파일에서 변수 주입 후 base64 인코딩)
  user_data_base64 = base64encode(templatefile("${path.module}/../../../userdata-examples/was-userdata-dev.sh", {
    domain_name = var.domain_name
    email        = var.email
  }))
}

