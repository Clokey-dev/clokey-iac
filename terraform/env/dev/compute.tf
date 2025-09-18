# EC2 Instance
module "ec2" {
  source                 = "../../modules/compute/ec2"
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t3.micro"
  subnet_id              = module.subnet_public_a.subnet_id
  name                   = "${local.name_prefix}-api" #API 서버용
  security_group_id_list = [module.sg_ec2.security_group_id]
  environment            = local.environment
  purpose                = "was"

  # SSH 키 설정 (AWS에서 미리 생성한 키 페어 이름)
  key_name = "dev-server-key"

  # 퍼블릭 IP 활성화 (웹 서버용)
  associate_public_ip_address = true

  # 루트 볼륨 설정
  root_volume_size      = 30
  root_volume_type      = "gp3"
  root_volume_encrypted = true

  # 종료 시 중지 (삭제하지 않음)
  instance_initiated_shutdown_behavior = "stop"

  # 사용자 데이터 (GitHub Secrets에서 주입)
  user_data = var.user_data
}

# ALB Target Group 추가
resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2.instance_id
  port             = 80
}

