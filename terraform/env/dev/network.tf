# VPC
module "vpc" {
  source      = "../../modules/network/vpc"
  cidr_block  = local.vpc_cidr
  name        = "${local.name_prefix}-vpc"
  environment = local.environment
  purpose     = "main"
}

# Internet Gateway
module "igw" {
  source      = "../../modules/network/igw"
  vpc_id      = module.vpc.vpc_id
  name        = "${local.name_prefix}-igw"
  environment = local.environment
  purpose     = "main"
}

# Public Route Table
module "route_table_public" {
  source           = "../../modules/network/route_table"
  vpc_id           = module.vpc.vpc_id
  gateway_id       = module.igw.gateway_id
  enable_igw_route = true
  name             = "${local.name_prefix}-public-rt"
  access_level     = "public"
  environment      = local.environment
  purpose          = "public"
}

# Private Route Table
module "route_table_private" {
  source           = "../../modules/network/route_table"
  vpc_id           = module.vpc.vpc_id
  enable_igw_route = false
  name             = "${local.name_prefix}-private-rt"
  access_level     = "private"
  environment      = local.environment
  purpose          = "private"
}

# Public Subnets
module "subnet_public_a" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = local.public_subnets.a
  az             = local.availability_zones.a
  map_public_ip  = true
  name           = "${local.name_prefix}-subnet-public-a"
  route_table_id = module.route_table_public.route_table_id
  environment    = local.environment
  purpose        = "public"
}

module "subnet_public_c" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = local.public_subnets.c
  az             = local.availability_zones.c
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
  cidr_block     = local.private_subnets.a
  az             = local.availability_zones.a
  map_public_ip  = false
  name           = "${local.name_prefix}-subnet-private-a"
  route_table_id = module.route_table_private.route_table_id
  environment    = local.environment
  purpose        = "private"
}

module "subnet_private_c" {
  source         = "../../modules/network/subnet"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = local.private_subnets.c
  az             = local.availability_zones.c
  map_public_ip  = false
  name           = "${local.name_prefix}-subnet-private-c"
  route_table_id = module.route_table_private.route_table_id
  environment    = local.environment
  purpose        = "private"
}

# Security Group
module "sg" {
  source = "../../modules/security/security_group"
  vpc_id = module.vpc.vpc_id

  environment         = local.environment
  purpose             = "was"
  security_group_name = "${local.name_prefix}-sg"

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

# Route53 - EC2 Public IP를 A 레코드로 설정 (새로운 hosted zone 생성)
module "route53" {
  source = "../../modules/network/route53"

  # 새로운 hosted zone 생성
  create_hosted_zone = true
  domain_name        = var.domain_name

  # A 레코드 생성
  create_a_record = true
  record_name     = "${local.environment}.${var.domain_name}"
  target_ip       = module.ec2.public_ip
  ttl             = 300
}
