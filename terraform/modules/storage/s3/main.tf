# S3 버킷 생성
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

# S3 버킷 버전 관리 설정
resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 버킷 서버 사이드 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_sse ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

# S3 버킷 공개 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.enable_block_public_access ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 버킷 공개 읽기 정책 (GET만 허용)
resource "aws_s3_bucket_policy" "public_read" {
  count  = var.enable_public_read ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.this]
}

# S3 버킷 수명 주기 정책 (선택적)
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle_policy && length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days = expiration.value.days
        }
      }
    }
  }
}
