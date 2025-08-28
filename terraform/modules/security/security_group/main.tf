resource "aws_security_group" "this" {
  name   = var.security_group_name
  vpc_id = var.vpc_id

  # 동적 인그레스 규칙 생성
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.use_cidr ? ingress.value.cidr_blocks : null
      security_groups = ingress.value.use_sg ? [ingress.value.source_security_group_id] : null
    }
  }

  # 동적 이그레스 규칙 생성
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(var.tags, {
    Name = "clokey-${var.purpose}-${var.environment}"
  })
}
