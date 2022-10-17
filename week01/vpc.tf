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

resource "aws_subnet" "subnet_web" {
  vpc_id            = aws_vpc.vpc_t101.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "subnet_t101"
  }
}

resource "aws_route_table_association" "rt_attach_subnet_web" {
  subnet_id      = aws_subnet.subnet_web.id
  route_table_id = aws_vpc.vpc_t101.default_route_table_id
}

resource "aws_route" "igw_attach_subnet_web" {
  route_table_id         = aws_vpc.vpc_t101.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_t101.id

}
