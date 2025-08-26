# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name
}

# Route53 A Record
resource "aws_route53_record" "a" {
  count = var.create_a_record ? 1 : 0

  zone_id = var.hosted_zone_id != null ? var.hosted_zone_id : (var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : null)
  name    = var.record_name
  type    = "A"
  ttl     = var.ttl
  records = [var.target_ip]
}
