provider "aws" {
  region  = "ap-northeast-2"
  profile = "hallsholicker"
}

module "week01" {
  source = "./week01"
}
