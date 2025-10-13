variable "vpc_id" {
  description = "VPC ID where the internet gateway will be attached"
  type        = string
}

variable "name" {
  description = "Name of the internet gateway"
  type        = string
}

variable "environment" {
  description = "Environment name (ex: dev or prod) - optional for shared resources"
  type        = string
  default     = null
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
