variable "domain_hallsholicker" {
  type    = string
  default = "hallsholicker.com"
}


variable "healthy_threshold" {
  default = 2
}

variable "unhealthy_threshold" {
  default = 2
}

variable "http_port" {
  default = 80
}

variable "https_port" {
  default = 443
}
