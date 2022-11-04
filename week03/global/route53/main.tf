provider "aws" {
  region  = "ap-northeast-2"
  profile = "hallsholicker"
}

### Get Domain Zone Info
data "aws_route53_zone" "zone_hallsholicker" {
  name         = var.domain_hallsholicker
  private_zone = false
}

data "terraform_remote_state" "acm" {
  backend = "local"

  config = {
    path = "../acm/terraform.tfstate"
  }

}

# ## Create Certificate Record
resource "aws_route53_record" "record_cert_hallsholicker" {
  for_each = {
    for dvo in data.terraform_remote_state.acm.outputs.hallsholicker_domain_validation_options : dvo.domain_name => {
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
