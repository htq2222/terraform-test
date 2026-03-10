output "cluster_id" {
  description = "The ECS cluster ID"
  value       = aws_ecs_cluster.cluster.id
}

output "cluster_name" {
  description = "The ECS cluster name"
  value       = aws_ecs_cluster.cluster.name
}

output "service_name" {
  description = "The ECS service name"
  value       = aws_ecs_service.service.name
}

output "task_definition_arn" {
  description = "The ARN of the latest task definition"
  value       = aws_ecs_task_definition.task.arn
}

output "task_role_arn" {
  description = "ARN of the ECS task role (for attaching additional policies)"
  value       = aws_iam_role.task.arn
}
