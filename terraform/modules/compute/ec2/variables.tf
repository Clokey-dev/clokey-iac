variable "ami"                 { type = string }

variable "instance_type"       { type = string }

variable "subnet_id"           { type = string }

variable "security_group_id_list" {
  description = "Security Group ID List"
  type        = list(string)
}

variable "name"                { type = string }
