output "subnet_id"       { value = aws_subnet.this.id }

output "route_table_id" {
  value = aws_route_table.public_rt != null ? aws_route_table.public_rt.id : null
}
