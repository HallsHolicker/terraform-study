### Create certificate
resource "aws_acm_certificate" "ssl_hallsholicker" {
  domain_name               = var.domain_hallsholicker
  subject_alternative_names = [format("*.%s", var.domain_hallsholicker)]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


### certificate validate
resource "aws_acm_certificate_validation" "certValidate_hallsholicker" {
  certificate_arn         = aws_acm_certificate.ssl_hallsholicker.arn
  validation_record_fqdns = [for record in aws_route53_record.record_cert_hallsholicker : record.fqdn]

}
