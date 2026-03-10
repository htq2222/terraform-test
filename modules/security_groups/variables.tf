variable "environment" {
  type        = string
  description = "The environment name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID in which to create the security groups"
}
