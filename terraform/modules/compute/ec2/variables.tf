variable "ami" { type = string }

variable "instance_type" { type = string }

variable "subnet_id" { type = string }

variable "security_group_id_list" {
  description = "Security Group ID List"
  type        = list(string)
}

variable "name" { type = string }

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: web, api, db)"
  type        = string
}

variable "tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
}
