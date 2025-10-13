# S3 Bucket
module "s3" {
  source      = "../../modules/storage/s3"
  bucket_name = "prod-clokey-storage-bucket"
  environment = local.environment
  purpose     = "storage"

  # Public read access (GET only) - AWS SDK로 업로드/삭제, 외부에서 읽기만 허용
  enable_public_read         = true
  enable_block_public_access = false # public read를 위해 비활성화
  enable_versioning          = true
  enable_sse                 = true
  sse_algorithm              = "AES256"

  tags = local.common_tags
}

