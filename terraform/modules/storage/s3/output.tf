output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = aws_s3_bucket.this.region
}

output "bucket_website_endpoint" {
  description = "The website endpoint of the bucket"
  value       = aws_s3_bucket.this.website_domain
  # Note: using website_domain instead of deprecated website_endpoint
}

output "bucket_public_url" {
  description = "The public URL for accessing objects in the bucket"
  value       = "https://${aws_s3_bucket.this.bucket_domain_name}"
}
