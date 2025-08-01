resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.subnet_ids
  tags       = { Name = var.name }
}

resource "aws_db_instance" "this" {
  allocated_storage      = var.storage
  engine                 = var.engine
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  manage_master_user_password = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true

  tags = { Name = var.name }
}
