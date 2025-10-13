variable "name" { type = string }

variable "subnet_ids" { type = list(string) }

variable "storage" { type = number }

variable "engine" { type = string }

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = null
}

variable "instance_class" { type = string }

variable "db_name" { type = string }

variable "username" { type = string }

variable "password" {
  description = "Password for RDS database"
  type        = string
  sensitive   = true
  default     = null
}

variable "security_group_id" { type = string }

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: app, analytics)"
  type        = string
  default     = "app"
}

# 네트워크 설정
variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "port" {
  description = "Database port"
  type        = number
  default     = null
}

# 백업 및 스냅샷 설정
variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot when deleting the database"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Name of final snapshot when skip_final_snapshot is false"
  type        = string
  default     = null
}

# 성능 설정
variable "multi_az" {
  description = "Whether to enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1"], var.storage_type)
    error_message = "Storage type must be one of: gp2, gp3, io1."
  }
}

variable "storage_encrypted" {
  description = "Whether to encrypt the storage"
  type        = bool
  default     = true
}

variable "iops" {
  description = "IOPS for io1 storage type"
  type        = number
  default     = null
}

# 파라미터 그룹 설정
variable "parameter_group_family" {
  description = "Parameter group family (e.g., mysql8.0, postgres13)"
  type        = string
  default     = null
}

variable "parameter_group_parameters" {
  description = "List of parameters to set in the parameter group"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# 보안 설정
variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Whether to enable auto minor version upgrade"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for the RDS resources"
  type        = map(string)
  default     = {}
}
