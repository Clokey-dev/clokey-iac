# S3 Backend Configuration
terraform {
  backend "s3" {
    bucket  = "clokey-terraform-state-dev"
    key     = "dev/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
