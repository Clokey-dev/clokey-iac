output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.main.arn
}

output "certificate_domain_name" {
  description = "Domain name of the certificate"
  value       = aws_acm_certificate.main.domain_name
}

output "certificate_validation_status" {
  description = "Validation status of the certificate"
  value       = aws_acm_certificate.main.status
}

output "certificate_validation_records" {
  description = "DNS validation records for the certificate"
  value       = aws_route53_record.cert_validation
}
