# ---------------------------------------------------------------
# DB Subnet Group
# ---------------------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name        = "${var.environment}-db-subnet-group"
  subnet_ids  = var.db_subnet_ids
  description = "Subnet group for ${var.environment} RDS instance"

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# RDS Instance
# ---------------------------------------------------------------
resource "aws_db_instance" "rds" {
  identifier        = "${var.environment}-rds"
  db_name           = var.db_name
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  multi_az            = var.multi_az
  storage_encrypted   = true
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.environment}-rds-final-snapshot"

  tags = {
    Name        = "${var.environment}-rds"
    Environment = var.environment
  }
}
