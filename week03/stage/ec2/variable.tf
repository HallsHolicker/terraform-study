variable "key_pair" {
  default = "t101Study"
}

variable "ec2_count" {
  default = 2
}

variable "asg_min_size" {
  default = 2
}

variable "asg_max_size" {
  default = 2
}


variable "healthy_threshold" {
  default = 2
}

variable "unhealthy_threshold" {
  default = 2
}
