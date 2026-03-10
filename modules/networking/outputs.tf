output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (for ALB)"
  value       = [for s in aws_subnet.public : s.id]
}

output "web_subnet_ids" {
  description = "List of web/app subnet IDs (for ECS tasks)"
  value       = [for s in aws_subnet.web : s.id]
}

output "db_subnet_ids" {
  description = "List of database subnet IDs (for RDS)"
  value       = [for s in aws_subnet.database : s.id]
}
