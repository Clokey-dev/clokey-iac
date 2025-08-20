variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
