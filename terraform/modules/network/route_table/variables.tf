variable "vpc_id" {
  type        = string
  description = "VPC ID for the route table"
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with this route table"
  type        = list(string)
}

variable "gateway_id" {
  type        = string
  default = ""
  description = "Internet Gateway ID for default route"
}

variable "name" {
  type        = string
  description = "Name tag"
}
