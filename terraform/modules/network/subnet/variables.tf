variable "vpc_id" {
  description = "VPC ID where the subnet will be created"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "az" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "map_public_ip" {
  description = "Whether to map public IP on launch"
  type        = bool
}

variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "route_table_id" {
  description = "Route table ID to associate with the subnet"
  type        = string
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
