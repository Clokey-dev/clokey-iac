# EC2 Instance
module "ec2" {
  source                 = "../../modules/compute/ec2"
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.subnet_public_a.subnet_id
  name                   = "${local.name_prefix}-ec2"
  security_group_id_list = [module.sg.security_group_id]
  environment            = var.environment
  purpose                = "was"
}

