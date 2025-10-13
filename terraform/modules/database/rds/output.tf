output "endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "RDS instance port"
  value       = aws_db_instance.this.port
}

output "database_name" {
  description = "RDS instance database name"
  value       = aws_db_instance.this.db_name
}

output "username" {
  description = "RDS instance master username"
  value       = aws_db_instance.this.username
  sensitive   = true
}

output "arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "resource_id" {
  description = "RDS instance resource ID"
  value       = aws_db_instance.this.resource_id
}

output "status" {
  description = "RDS instance status"
  value       = aws_db_instance.this.status
}

output "availability_zone" {
  description = "RDS instance availability zone"
  value       = aws_db_instance.this.availability_zone
}

output "subnet_group_name" {
  description = "RDS subnet group name"
  value       = aws_db_subnet_group.this.name
}

output "parameter_group_name" {
  description = "RDS parameter group name"
  value       = var.parameter_group_family != null ? aws_db_parameter_group.main[0].name : null
}
