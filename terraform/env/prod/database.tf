# RDS Instance
module "rds" {
  source = "../../modules/database/rds"
  name   = "${local.name_prefix}-rds"
  subnet_ids = [
    module.subnet_private_a.subnet_id,
    module.subnet_private_c.subnet_id
  ]
  storage           = 20
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  db_name           = "mydb"
  username          = var.rds_username
  security_group_id = module.sg.security_group_id
}

