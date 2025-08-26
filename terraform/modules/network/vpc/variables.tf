variable "cidr_block" { type = string }

variable "name" { type = string }

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: main, isolated)"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}
