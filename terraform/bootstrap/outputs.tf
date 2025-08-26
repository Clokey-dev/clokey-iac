output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = module.tf_state_bucket.bucket_name
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = module.tf_state_bucket.bucket_arn
}
