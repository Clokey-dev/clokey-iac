variable "vpc_id"        { type = string }

variable "cidr_block"    { type = string }

variable "az"            { type = string }

variable "map_public_ip" { type = bool }

variable "name"          { type = string }

variable "route_table_id" {
  type    = string
}
