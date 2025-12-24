output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : null
}

output "domain_name" {
  description = "Domain name of the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name : var.domain_name
}

output "record_name" {
  description = "Name of the A record"
  value = var.create_a_record ? (
    var.target_ip != null ? (
      length(aws_route53_record.a) > 0 ? aws_route53_record.a[0].name : null
      ) : (
      length(aws_route53_record.alias) > 0 ? aws_route53_record.alias[0].name : null
    )
  ) : null
}
