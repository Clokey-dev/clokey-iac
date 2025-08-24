# S3 + DynamoDB Backend Configuration
# 주석을 해제하고 실제 값으로 변경하여 사용
/*
terraform {
  backend "s3" {
    bucket         = "clokey-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "clokey-terraform-locks"
    encrypt        = true
  }
}
*/

