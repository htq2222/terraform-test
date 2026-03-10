variable "environment" {
  type        = string
  description = "The environment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID (required for target group)"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID to attach to the ALB"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the ACM certificate (e.g. app.example.com)"
  nullable    = false
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 hosted zone ID for DNS certificate validation"
  nullable    = false
}
