provider "aws" {
  region  = "ap-northeast-2"
  profile = "hallsholicker"
}

data "aws_availability_zones" "az_list" {
  state = "available"
}


resource "aws_vpc" "vpc_t101" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_t101"
  }
}

resource "aws_internet_gateway" "igw_t101" {
  vpc_id = aws_vpc.vpc_t101.id

  tags = {
    Name = "igw_t101"
  }
}

resource "aws_default_route_table" "rt_t101" {
  default_route_table_id = aws_vpc.vpc_t101.default_route_table_id

  tags = {
    Name = "rt_t101"
  }
}

resource "aws_subnet" "subnet_public" {
  #count             = length(data.aws_availability_zones.az_list.names)
  count             = "2"
  vpc_id            = aws_vpc.vpc_t101.id
  cidr_block        = "192.168.${var.subnet_cidr[count.index]}.0/24"
  availability_zone = element(data.aws_availability_zones.az_list.names, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_t101"
  }
}

resource "aws_route_table_association" "rt_attach_subnet_public" {
  count          = length(aws_subnet.subnet_public)
  subnet_id      = element(aws_subnet.subnet_public.*.id, count.index)
  route_table_id = aws_vpc.vpc_t101.default_route_table_id
}

resource "aws_route" "igw_attach_subnet_public" {
  route_table_id         = aws_vpc.vpc_t101.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_t101.id

}
