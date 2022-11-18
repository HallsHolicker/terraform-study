resource "aws_vpc" "vpc_t101" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc.tag.name
    Env  = var.env
  }
}

resource "aws_internet_gateway" "igw_t101" {
  vpc_id = aws_vpc.vpc_t101.id

  tags = {
    Name = "igw_t101"
    Env  = var.env
  }
}

resource "aws_default_route_table" "rt_public_t101" {
  default_route_table_id = aws_vpc.vpc_t101.default_route_table_id

  tags = {
    Name = "rt_t101"
    Env  = var.env
  }
}

resource "aws_route_table" "rt_private_t101" {
  for_each = toset(var.zone_private)
  vpc_id   = aws_vpc.vpc_t101.id

  tags = {
    Name = "rt_private_t101_${each.value}"
    Env  = var.env
  }
}

resource "aws_subnet" "subnet_public" {
  for_each          = toset(var.zone_public)
  vpc_id            = aws_vpc.vpc_t101.id
  cidr_block        = var.subnet_public[each.key].cidr
  availability_zone = each.value

  map_public_ip_on_launch = var.subnet_public[each.key].public_ip

  tags = {
    Name = var.subnet_public[each.key].tag.name
    Zone = each.value
    Env  = var.env
  }
}

resource "aws_subnet" "subnet_private" {
  for_each          = toset(var.zone_private)
  vpc_id            = aws_vpc.vpc_t101.id
  cidr_block        = var.subnet_private[each.key].cidr
  availability_zone = each.value

  tags = {
    Name = var.subnet_private[each.key].tag.name
    Zone = each.value
    Env  = var.env
  }
}

resource "aws_subnet" "subnet_nat" {
  for_each          = toset(var.zone_private)
  vpc_id            = aws_vpc.vpc_t101.id
  cidr_block        = var.subnet_nat[each.key].cidr
  availability_zone = each.value

  tags = {
    Name = var.subnet_nat[each.key].tag.name
    Zone = each.value
    Env  = var.env
  }
}

resource "aws_route_table_association" "rt_attach_subnet_public" {
  for_each       = toset(var.zone_public)
  subnet_id      = aws_subnet.subnet_public[each.key].id
  route_table_id = aws_vpc.vpc_t101.default_route_table_id
}

resource "aws_route_table_association" "rt_attach_subnet_private" {
  for_each       = toset(var.zone_private)
  subnet_id      = aws_subnet.subnet_private[each.key].id
  route_table_id = aws_route_table.rt_private_t101[each.key].id
}

resource "aws_route_table_association" "rt_attach_subnet_nat" {
  for_each       = toset(var.zone_private)
  subnet_id      = aws_subnet.subnet_nat[each.key].id
  route_table_id = aws_route_table.rt_private_t101[each.key].id
}

resource "aws_route" "igw_attach_subnet_public" {
  route_table_id         = aws_vpc.vpc_t101.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_t101.id

}

resource "aws_eip" "eip_nat" {
  for_each = toset(var.zone_private)
}

resource "aws_nat_gateway" "nat_gateway_private" {
  for_each      = var.enable_nat ? toset(var.zone_private) : toset({})
  subnet_id     = aws_subnet.subnet_nat[each.key].id
  allocation_id = aws_eip.eip_nat[each.key].id

  tags = {
    Name = "NAT Gateway ${each.value}"
  }
}

resource "aws_route" "nat_attach_rt_private" {
  for_each               = toset(var.zone_private)
  route_table_id         = aws_route_table.rt_private_t101[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway_private[each.key].id

}
