# 현재 AWS 계정 정보
data "aws_caller_identity" "current" {}

# Terraform 상태 파일을 저장할 S3 버킷 생성
module "tf_state_bucket" {
  source = "../modules/storage/s3"

  bucket_name = "clokey-terraform-state-${data.aws_caller_identity.current.account_id}"
  environment = var.environment
  purpose     = "tfstate"

  # 보안 설정
  enable_versioning         = true
  enable_sse               = true
  sse_algorithm            = "AES256"
  enable_block_public_access = true

  # 추가 태그
  tags = {
    Name = "Terraform State Bucket"
    Environment = var.environment
  }
}

