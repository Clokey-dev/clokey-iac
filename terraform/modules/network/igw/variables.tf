variable "vpc_id" { type = string }

variable "name" { type = string }

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: main)"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}
