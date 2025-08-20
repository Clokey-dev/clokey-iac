# EC2 Outputs
output "ec2_public_ip" {
  description = "EC2 Instance Public IP"
  value       = module.ec2.public_ip
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = module.ec2.instance_id
}

# Route53 Outputs
output "route53_record_name" {
  description = "Route53 A Record Name"
  value       = module.route53.record_name
  sensitive   = true
}

# Network Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = [module.subnet_public_a.subnet_id, module.subnet_public_c.subnet_id]
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = [module.subnet_private_a.subnet_id, module.subnet_private_c.subnet_id]
}

# Database Outputs
output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.endpoint
}

# Storage Outputs
output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = module.s3.bucket_name
}
