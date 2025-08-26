# Terraform 상태 파일을 저장할 S3 버킷 생성
resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "clokey-terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Bootstrap"
    ManagedBy   = "Terraform"
  }
}

# S3 버킷 버전 관리 활성화
resource "aws_s3_bucket_versioning" "tf_state_bucket" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 버킷 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_bucket" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 버킷 공개 액세스 차단
resource "aws_s3_bucket_public_access_block" "tf_state_bucket" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 현재 AWS 계정 정보
data "aws_caller_identity" "current" {}

