output "ec2_sg_lb_id" {
  value       = aws_security_group.sg_lb.id
  description = "SG LB ID"

}
