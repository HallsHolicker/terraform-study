variable "key_pair" {
  default = "t101Study"
}

variable "domain_hallsholicker" {
  type    = string
  default = "hallsholicker.com"
}

variable "subnet_cidr" {
  default = {
    "0" = "0",
    "1" = "1",
    "2" = "2",
    "3" = "3"
  }
}

variable "ec2_count" {
  default = 2
}

variable "healthy_threshold" {
  default = 2
}

variable "unhealthy_threshold" {
  default = 2
}
