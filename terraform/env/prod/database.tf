# RDS Instance
module "rds" {
  source = "../../modules/database/rds"
  name   = "${local.name_prefix}-rds"
  subnet_ids = [
    module.subnet_private_a.subnet_id,
    module.subnet_private_c.subnet_id
  ]
  storage           = 50
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.small"
  db_name           = "mydb"
  username          = var.rds_username
  security_group_id = module.sg_rds.security_group_id
  environment       = local.environment
  purpose           = "app"

  # 네트워크 설정
  publicly_accessible = false # 프라이빗 서브넷에 위치하므로 false

  # 백업 설정
  backup_retention_period = 30 # 프로덕션에서는 30일 보관
  backup_window           = "02:00-03:00"
  maintenance_window      = "sun:02:00-sun:03:00"

  # 성능 설정
  multi_az          = true # 프로덕션에서는 Multi-AZ 활성화
  storage_type      = "gp3"
  storage_encrypted = true

  # 보안 설정
  deletion_protection = true # 프로덕션에서는 삭제 보호 활성화

  # 파라미터 그룹 설정 (선택적)
  parameter_group_family = "mysql8.0"
  parameter_group_parameters = [
    {
      name  = "max_connections"
      value = "200"
    },
    {
      name  = "innodb_buffer_pool_size"
      value = "{DBInstanceClassMemory*3/4}"
    }
  ]
}

