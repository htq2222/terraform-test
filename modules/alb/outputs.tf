output "lb_dns_name" {
  description = "The public DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}

output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "The ARN of the target group (consumed by ECS module)"
  value       = aws_lb_target_group.tg.arn
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}
