variable "vpc_id" { type = string }

variable "cidr_block" { type = string }

variable "az" { type = string }

variable "map_public_ip" { type = bool }

variable "name" { type = string }

variable "route_table_id" {
  type = string
}

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: public, private)"
  type        = string
}

variable "tags" {
  description = "Additional tags for the subnet"
  type        = map(string)
  default     = {}
}
