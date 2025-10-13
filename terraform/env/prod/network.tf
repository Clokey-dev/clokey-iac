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
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      use_cidr                 = false
      use_sg                   = true
      source_security_group_id = module.sg_alb.security_group_id
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

# ALB Security Group
module "sg_alb" {
  source = "../../modules/security/security_group"
  vpc_id = module.vpc.vpc_id

  environment         = local.environment
  purpose             = "alb"
  security_group_name = "${local.name_prefix}-sg-alb"

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

# ACM Certificate
module "acm" {
  source = "../../modules/network/acm"

  name_prefix    = local.name_prefix
  domain_name    = var.domain_name
  hosted_zone_id = module.route53_zone.hosted_zone_id

  tags = local.common_tags
}

# Application Load Balancer
module "alb" {
  source = "../../modules/network/alb"

  name_prefix     = local.name_prefix
  internal        = false
  security_groups = [module.sg_alb.security_group_id]
  subnet_ids      = [module.subnet_public_a.subnet_id, module.subnet_public_c.subnet_id]
  vpc_id          = module.vpc.vpc_id

  target_group_port     = 80
  target_group_protocol = "HTTP"

  health_check_path    = "/health"
  health_check_matcher = "200"

  certificate_arn = module.acm.certificate_arn

  tags = local.common_tags
}

# Route53 - Hosted Zone 생성
module "route53_zone" {
  source = "../../modules/network/route53"

  # 새로운 hosted zone 생성
  create_hosted_zone = true
  domain_name        = var.domain_name
  create_a_record    = false

  tags = local.common_tags
}

# Route53 - ALB를 A 레코드로 설정 (ALB 생성 후)
module "route53_record" {
  source = "../../modules/network/route53"

  # 기존 hosted zone 사용
  create_hosted_zone = false
  hosted_zone_id     = module.route53_zone.hosted_zone_id

  # A 레코드 생성 (ALB로 변경)
  create_a_record = true
  record_name     = "${local.environment}.${var.domain_name}"
  target_alias    = module.alb.load_balancer_dns_name
  target_zone_id  = module.alb.load_balancer_zone_id
  ttl             = 300

  depends_on = [module.alb]
}

