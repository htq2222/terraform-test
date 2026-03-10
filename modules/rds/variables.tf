variable "environment" {
  type        = string
  description = "The environment name"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the DB subnet group"
}

variable "db_sg_id" {
  type        = string
  description = "Security group ID to attach to the RDS instance"
}

variable "db_username" {
  type        = string
  description = "RDS master username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "RDS master password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "Name of the initial database"
  default     = "appdb"
}

variable "engine_version" {
  type        = string
  description = "Postgres engine version"
  default     = "16"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GiB"
  default     = 20
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection"
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot on destroy (set false for prod)"
  default     = false
}
