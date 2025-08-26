variable "vpc_id" {
  type        = string
  description = "VPC ID for the route table"
}

variable "access_level" {
  description = "Internet access enabled (예: public, private)"
  type        = string
}

variable "gateway_id" {
  type        = string
  default     = ""
  description = "Internet Gateway ID for default route"
}

variable "destination_cidr_block" {
  description = "(option) IGW route CIDR (default: 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "name" {
  type        = string
  description = "Name tag"
}

variable "enable_igw_route" {
  description = "Whether IGW routing is added"
  type        = bool
  default     = false
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
  description = "Additional tags for the route table"
  type        = map(string)
  default     = {}
}
