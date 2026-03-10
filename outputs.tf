output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.lb_dns_name   # HQ
}

#>>> HQ
output "ecs_cluster_id" {
  description = "The ECS cluster ID"
  value       = module.ecs.cluster_id
}

output "rds_endpoint" {
  description = "The RDS instance endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "vpc_id" {
  description = "The VPC ID"
  value       = module.networking.vpc_id
}
#<<< HQ
