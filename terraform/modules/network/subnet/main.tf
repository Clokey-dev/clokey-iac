resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = var.map_public_ip

  tags = { Name = var.name }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = var.route_table_id
}