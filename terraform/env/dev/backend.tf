# S3 Backend Configuration
terraform {
  backend "s3" {
    bucket  = "clokey-terraform-state-116541188992"
    key     = "dev/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
