# S3 Bucket
module "s3" {
  source      = "../../modules/storage/s3"
  bucket_name = "prod-clokey-storage-bucket"
  environment = local.environment
  purpose     = "storage"

  enable_public_read         = false
  enable_block_public_access = true
  enable_versioning          = true
  enable_sse                 = true
  sse_algorithm              = "AES256"

  tags = local.common_tags
}

