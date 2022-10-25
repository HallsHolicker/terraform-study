provider "aws" {
  region  = "ap-northeast-2"
  profile = "hallsholicker"
}

provider "aws" {
  alias   = "vriginia"
  region  = "us-east-1"
  profile = "hallsholicker"
}


# module "week01" {
#   source = "./week01"
# }

module "week02" {
  source = "./week02"
}

