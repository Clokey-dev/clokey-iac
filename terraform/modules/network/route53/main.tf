# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name

  tags = var.tags
}

# Route53 A Record (IP)
resource "aws_route53_record" "a" {
  count = var.create_a_record && var.target_ip != null && var.record_name != null ? 1 : 0

  zone_id = var.hosted_zone_id != null ? var.hosted_zone_id : (var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : null)
  name    = var.record_name
  type    = "A"
  ttl     = var.ttl
  records = [var.target_ip]
}

# Route53 A Record (ALB Alias)
resource "aws_route53_record" "alias" {
  count = var.create_a_record && var.target_alias != null && var.target_zone_id != null && var.record_name != null ? 1 : 0

  zone_id = var.hosted_zone_id != null ? var.hosted_zone_id : (var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : null)
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.target_alias
    zone_id                = var.target_zone_id
    evaluate_target_health = true
  }
}
