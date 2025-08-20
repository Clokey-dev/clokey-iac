# S3 Bucket
module "s3" {
  source      = "../../modules/storage/s3"
  bucket_name = "${local.name_prefix}-bucket"
  environment = var.environment
  purpose     = "storage"
}

