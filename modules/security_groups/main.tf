resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sgrp"
  description = "Allow HTTP/HTTPS inbound from internet to ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-alb-sgrp"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP inbound from internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS inbound from internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_to_ecs" {
  type                     = "egress"
  security_group_id        = aws_security_group.alb.id
  description              = "Allow outbound to ECS tasks on port 80"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group" "ecs" {
  name        = "${var.environment}-ecs-sgrp"
  description = "Allow inbound from ALB only"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-ecs-sgrp"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_ingress_from_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow HTTP from ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  security_group_id = aws_security_group.ecs.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "database" {
  name        = "${var.environment}-db-sgrp"
  description = "Allow Postgres inbound from ECS tasks only"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-db-sgrp"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "db_ingress_from_ecs" {
  type                     = "ingress"
  security_group_id        = aws_security_group.database.id
  description              = "Allow Postgres from ECS tasks"
  from_port                = 5432  # Postgres port
  to_port                  = 5432  # Postgres port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  security_group_id = aws_security_group.database.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
