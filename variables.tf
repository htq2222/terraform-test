variable "environment" {
  type        = string   # HQ
  description = "the environment name"
}

variable "service" {
  type        = string   # HQ
  description = "the service name"
}

#>>> HQ - username derived from local environment variable TF_VAR_db_username
variable "db_username" {
  type        = string
  description = "db username"
  sensitive   = true
}
#<<< HQ

#>>> HQ - password derived from local environment variable TF_VAR_db_password
variable "db_password" {
  type        = string
  description = "db password"
  sensitive   = true
}
#<<< HQ

#>>> HQ - region derived from terraform.tfvars.json
variable "region" {
  type        = string
  description = "AWS region"
}
#<<< HQ

#>>> HQ
variable "domain_name" {
  type        = string
  description = "The domain name for the ACM certificate (e.g. app.example.com)"
  nullable    = false
}

variable "route53_zone_id" {
  type        = string
  description = "The Route53 hosted zone ID for DNS validation"
  nullable    = false
}
#<<< HQ
