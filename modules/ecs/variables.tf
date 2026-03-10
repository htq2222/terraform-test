variable "environment" {
  type        = string
  description = "The environment name"
}

variable "service" {
  type        = string
  description = "The service name (e.g. nginx)"
}

variable "region" {
  type        = string
  description = "AWS region (used for CloudWatch log config)"
  default     = "eu-west-2"
}

variable "web_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs in which ECS tasks run"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group ID to attach to ECS tasks"
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group ARN to register the ECS service with"
}

variable "container_image" {
  type        = string
  description = "Docker image to run (e.g. nginx:latest or ECR URI)"
  default     = "nginx:latest"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}

variable "task_cpu" {
  type        = string
  description = "Fargate task CPU units (256, 512, 1024, ...)"
  default     = "256"
}

variable "task_memory" {
  type        = string
  description = "Fargate task memory in MiB"
  default     = "512"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS task instances to run"
  default     = 1
}
