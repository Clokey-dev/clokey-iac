# VPC
module "vpc" {
  source      = "../../modules/network/vpc"
  cidr_block  = "10.0.0.0/16"
  name        = "${local.name_prefix}-vpc"
  purpose     = "main"
  environment = local.environment
  tags        = local.common_tags
}

# Internet Gateway
module "igw" {
  source  = "../../modules/network/igw"
  vpc_id  = module.vpc.vpc_id
  name    = "${local.name_prefix}-igw"
  purpose = "main"
}

# Public Route Table
module "route_table_public" {
  source           = "../../modules/network/route_table"
  vpc_id           = module.vpc.vpc_id
  gateway_id       = module.igw.gateway_id
  enable_igw_route = true
  name             = "${local.name_prefix}-public-rt"
  access_level     = "public"
  purpose          = "public"
}

# Private Route Table
module "route_table_private" {
  source           = "../../modules/network/route_table"
  vpc_id           = module.vpc.vpc_id
  enable_igw_route = false
  name             = "${local.name_prefix}-private-rt"
  access_level     = "private"
  purpose          = "private"
}

# Public Subnets
module "subnet_public_a" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.1.0/24"
  az             = "ap-northeast-2a"
  map_public_ip  = true
  name           = "${local.name_prefix}-subnet-public-a"
  route_table_id = module.route_table_public.route_table_id
  environment    = local.environment
  purpose        = "public"
}

module "subnet_public_c" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.2.0/24"
  az             = "ap-northeast-2c"
  map_public_ip  = true
  name           = "${local.name_prefix}-subnet-public-c"
  route_table_id = module.route_table_public.route_table_id
  environment    = local.environment
  purpose        = "public"
}

# Private Subnets
module "subnet_private_a" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.11.0/24"
  az             = "ap-northeast-2a"
  map_public_ip  = false
  name           = "${local.name_prefix}-subnet-private-a"
  route_table_id = module.route_table_private.route_table_id
  environment    = local.environment
  purpose        = "private"
}

module "subnet_private_c" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.12.0/24"
  az             = "ap-northeast-2c"
  map_public_ip  = false
  name           = "${local.name_prefix}-subnet-private-c"
  route_table_id = module.route_table_private.route_table_id
  environment    = local.environment
  purpose        = "private"
}

# EC2 Security Group
module "sg_ec2" {
  source = "../../modules/security/security_group"
  vpc_id = module.vpc.vpc_id

  environment         = local.environment
  purpose             = "ec2"
  security_group_name = "${local.name_prefix}-sg-ec2"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
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

# RDS Security Group
module "sg_rds" {
  source = "../../modules/security/security_group"
  vpc_id = module.vpc.vpc_id

  environment         = local.environment
  purpose             = "rds"
  security_group_name = "${local.name_prefix}-sg-rds"

  ingress_rules = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      use_cidr                 = false
      use_sg                   = true
      source_security_group_id = module.sg_ec2.security_group_id
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


