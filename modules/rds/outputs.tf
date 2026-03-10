output "db_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.rds.endpoint
  sensitive   = true
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.rds.db_name
}

output "db_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.rds.identifier
}
