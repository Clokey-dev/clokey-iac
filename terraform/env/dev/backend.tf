# S3 Backend Configuration
# 로컬 테스트용 (실제 값 사용)
terraform {
  backend "s3" {
    bucket  = "clokey-terraform-state-116541188992"
    key     = "dev/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
