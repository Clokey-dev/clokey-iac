# DB 파라미터 그룹 생성 (선택적)
resource "aws_db_parameter_group" "main" {
  count = var.parameter_group_family != null ? 1 : 0

  family = var.parameter_group_family
  name   = "${var.name}-parameter-group"

  dynamic "parameter" {
    for_each = var.parameter_group_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(var.tags, { Name = "clokey-${var.purpose}-${var.environment}-pg" })
}

# DB 서브넷 그룹
resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "clokey-${var.purpose}-${var.environment}" })
}

# RDS 인스턴스
resource "aws_db_instance" "this" {
  allocated_storage = var.storage
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_name           = var.db_name
  username          = var.username

  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]

  # 네트워크 설정
  publicly_accessible = var.publicly_accessible
  port                = var.port

  # 백업 및 스냅샷 설정
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  # 성능 설정
  multi_az          = var.multi_az
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  iops              = var.iops

  # 파라미터 그룹 설정
  parameter_group_name = var.parameter_group_family != null ? aws_db_parameter_group.main[0].name : null

  # 보안 설정
  deletion_protection        = var.deletion_protection
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  tags = merge(var.tags, { Name = var.name })
}
