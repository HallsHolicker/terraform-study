data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}


data "terraform_remote_state" "ec2" {
  backend = "local"
  config = {
    path = "../ec2/terraform.tfstate"
  }
}

data "terraform_remote_state" "acm" {
  backend = "local"
  config = {
    path = "../../global/acm/terraform.tfstate"
  }
}

data "terraform_remote_state" "route53" {
  backend = "local"
  config = {
    path = "../../global/route53/terraform.tfstate"
  }
}
