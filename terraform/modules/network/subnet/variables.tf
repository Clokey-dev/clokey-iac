variable "vpc_id"        { type = string }

variable "cidr_block"    { type = string }

variable "az"            { type = string }

variable "map_public_ip" { type = bool }

variable "gateway_id" {
  type    = string
  default = ""
}

variable "name"          { type = string }

variable "associate_route_table" {
  type    = bool
  default = false
}

variable "route_table_id" {
  type    = string
  default = ""
}
