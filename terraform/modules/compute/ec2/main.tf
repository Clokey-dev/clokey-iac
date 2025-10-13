# EC2 인스턴스 생성
resource "aws_instance" "this" {
  ami                                  = var.ami
  instance_type                        = var.instance_type
  subnet_id                            = var.subnet_id
  vpc_security_group_ids               = var.security_group_id_list
  key_name                             = var.key_name
  private_ip                           = var.private_ip
  associate_public_ip_address          = var.associate_public_ip_address
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  monitoring                           = var.monitoring

  # 사용자 데이터 설정 (변수로 주입받거나 기본 파일 사용)
  # AWS는 user_data를 base64로 인코딩하여 전달해야 함
  user_data_base64            = var.user_data != null ? var.user_data : null
  user_data_replace_on_change = false # UserData 변경해도도 인스턴스 유지 (수동 재시작 필요)

  # 루트 볼륨 설정
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    delete_on_termination = var.root_volume_delete_on_termination
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

# 추가 EBS 볼륨 생성 및 연결
resource "aws_ebs_volume" "additional" {
  count = length(var.additional_ebs_volumes)

  availability_zone = aws_instance.this.availability_zone
  size              = var.additional_ebs_volumes[count.index].size
  type              = var.additional_ebs_volumes[count.index].volume_type
  encrypted         = var.additional_ebs_volumes[count.index].encrypted

  tags = merge(var.additional_ebs_volumes[count.index].tags, {
    Name         = "clokey-${var.purpose}-${var.environment}-vol-${count.index + 1}"
    InstanceName = var.name
  })
}

# 추가 EBS 볼륨을 EC2 인스턴스에 연결
resource "aws_volume_attachment" "additional" {
  count = length(var.additional_ebs_volumes)

  device_name = var.additional_ebs_volumes[count.index].device_name
  volume_id   = aws_ebs_volume.additional[count.index].id
  instance_id = aws_instance.this.id

  # 인스턴스가 중지된 상태에서만 볼륨 분리 가능
  stop_instance_before_detaching = true
}
