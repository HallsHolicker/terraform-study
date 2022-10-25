### Get Domain Zone Info
data "aws_route53_zone" "zone_hallsholicker" {
  name         = var.domain_hallsholicker
  private_zone = false
}

### Create Certificate Record
resource "aws_route53_record" "record_cert_hallsholicker" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_hallsholicker.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_hallsholicker.zone_id
}

### ALB record
resource "aws_route53_record" "record_cname_alb" {
  zone_id = data.aws_route53_zone.zone_hallsholicker.zone_id
  name    = format("alb.%s", var.domain_hallsholicker)
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.alb_t101.dns_name]
}

### nlb record
resource "aws_route53_record" "record_cname_nlb" {
  zone_id = data.aws_route53_zone.zone_hallsholicker.zone_id
  name    = format("nlb.%s", var.domain_hallsholicker)
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.nlb_t101.dns_name]
}
