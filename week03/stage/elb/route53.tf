### ALB record
resource "aws_route53_record" "record_cname_alb" {
  zone_id = data.terraform_remote_state.route53.outputs.route53_hallsholicker_zone_id
  name    = format("alb.%s", var.domain_hallsholicker)
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.alb_t101.dns_name]
}

### nlb record
resource "aws_route53_record" "record_cname_nlb" {
  zone_id = data.terraform_remote_state.route53.outputs.route53_hallsholicker_zone_id
  name    = format("nlb.%s", var.domain_hallsholicker)
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.nlb_t101.dns_name]
}
