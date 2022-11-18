variable "env" {
  default = "dev"

}
variable "vpc" {
  default = {
    cidr = "192.168.0.0/16"
    tag = {
      name = "vpc-t101"
    }
  }
}

variable "zone_public" {
  default = ["ap-northeast-2a", "ap-northeast-2b"]
}

variable "zone_private" {
  default = ["ap-northeast-2a", "ap-northeast-2b"]
}

variable "subnet_public" {
  default = {
    ap-northeast-2a = {
      cidr      = "192.168.0.0/24"
      public_ip = true
      tag = {
        name = "subnet-public-1-t101"
      }
    }
    ap-northeast-2b = {
      cidr      = "192.168.1.0/24"
      public_ip = true
      tag = {
        name = "subnet-public-2-t101"
      }
    }
  }
}

variable "subnet_private" {
  default = {
    ap-northeast-2a = {
      cidr = "192.168.10.0/24"
      tag = {
        name = "subnet-private-1-t101"
      }
    }
    ap-northeast-2b = {
      cidr = "192.168.11.0/24"
      tag = {
        name = "subnet-private-2-t101"
      }
    }
  }
}

variable "subnet_nat" {
  default = {
    ap-northeast-2a = {
      cidr = "192.168.100.0/24"
      tag = {
        name = "subnet-nat-1-t101"
      }
    }
    ap-northeast-2b = {
      cidr = "192.168.101.0/24"
      tag = {
        name = "subnet-nat-2-t101"
      }
    }
  }
}

variable "enable_nat" {
  type    = bool
  default = true
}
