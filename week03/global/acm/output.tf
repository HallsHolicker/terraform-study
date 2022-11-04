output "acm_ssl_hallsholicker_arn" {
  value       = aws_acm_certificate.ssl_hallsholicker.arn
  description = "SSL ACM ARN"
}

output "hallsholicker_domain_validation_options" {
  value       = aws_acm_certificate.ssl_hallsholicker.domain_validation_options
  description = "Hallsholicker ACM Validation FQDN"
}
