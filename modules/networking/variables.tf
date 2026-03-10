variable "environment" {
  type        = string
  description = "The environment name"
}

variable "region" {
  type        = string
  description = "AWS region (used to derive AZ names)"
}
