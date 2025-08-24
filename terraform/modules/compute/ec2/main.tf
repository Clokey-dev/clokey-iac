resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_id_list
  user_data              = file("${path.module}/userdata.sh")  # 👈 여기 추가

  tags = {
    Name = var.name
  }
}
