provider "aws" {
  region  = "ap-northeast-2"
  profile = "hallsholicker"
}

data "terraform_remote_state" "route53" {
  backend = "local"

  config = {
    path = "../route53/terraform.tfstate"
  }
}

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
  validation_record_fqdns = [for record in data.terraform_remote_state.route53.outputs.record_cert_hallsholicker : record.fqdn]

}
