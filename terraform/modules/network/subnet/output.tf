output "subnet_id"       { value = aws_subnet.this.id }

output "route_table_id" {
  value = var.gateway_id != "" ? aws_route_table.public_rt.id : null
}
