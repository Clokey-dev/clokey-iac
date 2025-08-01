resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_route" "default_route" {
  for_each = var.gateway_id != "" ? { "default" = var.gateway_id } : {}

  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.value
}

resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this.id
}
