output "route53_hallsholicker_zone_id" {
  value       = data.aws_route53_zone.zone_hallsholicker.zone_id
  description = "HAllsholicker Zone ID"

}

output "record_cert_hallsholicker" {
  value       = aws_route53_record.record_cert_hallsholicker
  description = "Hallsholicker ACM domain validation options"
}
