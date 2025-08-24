variable "bucket_name" {
  description = "S3 bucket name"
  type = string
}

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: tfstate, image)"
  type        = string
}

variable "enable_versioning" {
  description = "Whether version management is enabled"
  type        = bool
  default     = false
}

variable "enable_sse" {
  description = "Whether server-side encryption is enabled"
  type        = bool
  default     = false
}

variable "enable_block_public_access" {
  description = "Whether internet access blocking is enabled"
  type        = bool
  default     = true
}