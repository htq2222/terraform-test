# ---------------------------------------------------------------
# IAM — Execution Role (ECR pull, CloudWatch logs)
# ---------------------------------------------------------------
resource "aws_iam_role" "execution" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = {
    Name        = "${var.environment}-ecs-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ---------------------------------------------------------------
# IAM — Task Role (runtime permissions for the container)
# ---------------------------------------------------------------
resource "aws_iam_role" "task" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = {
    Name        = "${var.environment}-ecs-task-role"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# CloudWatch Log Group
# ---------------------------------------------------------------
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}/${var.service}"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    Service     = var.service
  }
}

# ---------------------------------------------------------------
# ECS Cluster
# ---------------------------------------------------------------
resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-cluster"

  tags = {
    Name        = "${var.environment}-cluster"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# Task Definition
# ---------------------------------------------------------------
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.environment}-${var.service}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.execution.arn

  container_definitions = jsonencode([{
    name  = "${var.service}-container"
    image = var.container_image

    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = {
    Name        = "${var.environment}-${var.service}-task"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------
# ECS Service
# ---------------------------------------------------------------
resource "aws_ecs_service" "service" {
  name            = "${var.environment}-${var.service}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.web_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.service}-container"
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_task_definition.task]

  tags = {
    Name        = "${var.environment}-${var.service}"
    Environment = var.environment
  }
}
