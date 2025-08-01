resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = var.map_public_ip

  tags = { Name = var.name }
}

resource "aws_route_table" "public_rt" {
  count  = var.gateway_id != "" ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = { Name = "${var.name}-rt" }
}

resource "aws_route_table_association" "assoc" {
  count          = var.associate_route_table ? 1 : 0
  subnet_id      = aws_subnet.this.id
  route_table_id = var.route_table_id
}