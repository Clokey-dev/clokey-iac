variable "name" { type = string }

variable "subnet_ids" { type = list(string) }

variable "storage" { type = number }

variable "engine" { type = string }

variable "instance_class" { type = string }

variable "db_name" { type = string }

variable "username" { type = string }

variable "security_group_id" { type = string }

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: app, analytics)"
  type        = string
  default     = "app"
}

variable "tags" {
  description = "Additional tags for the RDS resources"
  type        = map(string)
  default     = {}
}
