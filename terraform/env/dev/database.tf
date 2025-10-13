# RDS Instance
module "rds" {
  source = "../../modules/database/rds"
  name   = "${local.name_prefix}-rds"
  subnet_ids = [
    module.subnet_private_a.subnet_id,
    module.subnet_private_c.subnet_id
  ]
  storage           = 30
  engine            = "mysql"
  engine_version    = "8.0.42"
  instance_class    = "db.t3.micro"
  db_name           = "clokey_db"
  username          = var.rds_username
  password          = var.rds_password
  security_group_id = module.sg_rds.security_group_id
  environment       = local.environment
  purpose           = "app"

  # 네트워크 설정
  publicly_accessible = false # 프라이빗 서브넷에 위치하므로 false

  # 백업 설정
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  # 성능 설정
  multi_az          = false # 개발 환경에서는 단일 AZ
  storage_type      = "gp3"
  storage_encrypted = true

  # 보안 설정
  deletion_protection = false # 개발 환경에서는 삭제 보호 비활성화

  # 파라미터 그룹 설정
  parameter_group_family = "mysql8.0"
  parameter_group_parameters = [
    {
      name  = "max_connections"
      value = "100"
    },
    {
      name  = "innodb_buffer_pool_size"
      value = "{DBInstanceClassMemory*3/4}"
    }
  ]
}

