variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (ex: dev or prod) - optional for shared resources"
  type        = string
  default     = null
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
