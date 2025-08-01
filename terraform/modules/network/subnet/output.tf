output "subnet_id"       { value = aws_subnet.this.id }

output "route_table_id" {
  value = try(length(aws_route_table.public_rt) > 0 ? aws_route_table.public_rt[0].id : null, null)
}
