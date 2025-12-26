# S3 Backend Configuration
terraform {
  backend "s3" {
    bucket  = "clokey-terraform-state-prod"
    key     = "prod/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

