output "elb_alb_target_arn" {
  value       = aws_lb_target_group.alb_target.arn
  description = "ALB Target ARN"
}

output "elb_nlb_target_arn" {
  value       = aws_lb_target_group.nlb_target.arn
  description = "NLB Target ARN"
}
