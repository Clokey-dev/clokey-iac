provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "../../modules/network/vpc"
  cidr_block = var.vpc_cidr_block
  name       = "${var.environment}-vpc"
}

module "igw" {
  source = "../../modules/network/igw"
  vpc_id = module.vpc.vpc_id
  name   = "${var.environment}-igw"
}

####################
# Public Subnets
####################

module "subnet_public_a" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.1.0/24"
  az             = "ap-northeast-2a"
  map_public_ip  = true
  associate_route_table = false
  gateway_id     = module.igw.gateway_id
  name           = "${var.environment}-subnet-public-a"
}

module "subnet_public_c" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.2.0/24"
  az             = "ap-northeast-2c"
  map_public_ip  = true
  associate_route_table = false
  gateway_id     = module.igw.gateway_id
  name           = "${var.environment}-subnet-public-c"
}

module "route_table_public" {
  source     = "../../modules/network/route_table"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.subnet_public_a.subnet_id, module.subnet_public_c.subnet_id]
  gateway_id = module.igw.gateway_id
  name       = "${var.environment}-public-rt"
  route_table_id = module.subnet_public_a.route_table_id
}


####################
# Private Subnets
####################

module "subnet_private_a" {
  source        = "../../modules/network/subnet"
  vpc_id        = module.vpc.vpc_id
  cidr_block    = "10.0.11.0/24"
  az            = "ap-northeast-2a"
  map_public_ip = false
  name          = "${var.environment}-subnet-private-a"
}

module "subnet_private_c" {
  source        = "../../modules/network/subnet"
  vpc_id        = module.vpc.vpc_id
  cidr_block    = "10.0.12.0/24"
  az            = "ap-northeast-2c"
  map_public_ip = false
  name          = "${var.environment}-subnet-private-c"
}

module "route_table_private" {
  source     = "../../modules/network/route_table"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.subnet_private_a.subnet_id, module.subnet_private_c.subnet_id]
  name       = "${var.environment}-private-rt"
  route_table_id = module.subnet_private_a.route_table_id
}

module "sg" {
  source       = "../../modules/security/security_group"
  vpc_id       = module.vpc.vpc_id

  environment         = var.environment
  purpose             = "was"
  security_group_name = "${var.environment}-sg"

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      use_cidr    = true
      use_sg      = false
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      use_cidr    = true
      use_sg      = false
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      use_cidr    = true
      use_sg      = false
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      use_cidr    = true
      use_sg      = false
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      use_cidr    = true
      use_sg      = false
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "s3" {
  source      = "../../modules/storage/s3"
  bucket_name = "clokey-${var.environment}-bucket"
  environment = ""
  purpose     = ""
}

module "ec2" {
  source          = "../../modules/compute/ec2"
  ami             = var.ami
  instance_type   = "t3.micro"
  subnet_id = module.subnet_public_a.subnet_id
  name            = "${var.environment}-ec2"
  security_group_id_list = [module.sg.security_group_id]
}

module "rds" {
  source             = "../../modules/database/rds"
  name               = "${var.environment}-rds"
  subnet_ids = [
    module.subnet_private_a.subnet_id,
    module.subnet_private_c.subnet_id
  ]
  storage            = 20
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  db_name            = "mydb"
  username           = var.rds_username
  security_group_id  = module.sg.security_group_id
}
