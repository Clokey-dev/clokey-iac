variable "create_hosted_zone" {
  description = "Whether to create a new hosted zone"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
  default     = null
}

variable "hosted_zone_id" {
  description = "Existing hosted zone ID (if not creating new one)"
  type        = string
  default     = null
}

variable "create_a_record" {
  description = "Whether to create an A record"
  type        = bool
  default     = true
}

variable "record_name" {
  description = "Name for the A record (e.g., 'api.example.com')"
  type        = string
  default     = null
}

variable "target_ip" {
  description = "Target IP address for the A record"
  type        = string
  default     = null
}

variable "target_alias" {
  description = "Target alias (e.g., ALB DNS name) for the A record"
  type        = string
  default     = null
}

variable "target_zone_id" {
  description = "Target zone ID for alias records (e.g., ALB zone ID)"
  type        = string
  default     = null
}

variable "ttl" {
  description = "TTL for the A record"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Additional tags for the Route53 resources"
  type        = map(string)
  default     = {}
}
