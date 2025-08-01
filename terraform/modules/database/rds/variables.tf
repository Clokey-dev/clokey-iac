variable "name"               { type = string }

variable "subnet_ids"         { type = list(string) }

variable "storage"            { type = number }

variable "engine"             { type = string }

variable "instance_class"     { type = string }

variable "db_name"            { type = string }

variable "username"           { type = string }

variable "security_group_id"  { type = string }
