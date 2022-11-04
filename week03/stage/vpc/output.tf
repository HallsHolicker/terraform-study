output "vpc_id" {
  value       = aws_vpc.vpc_t101.id
  description = "VPC ID"
}

output "vpc_subnmet_public" {
  value       = aws_subnet.subnet_public
  description = "VPC Subnet"
}
