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

# 볼륨 설정
variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root volume (gp2, gp3, io1, io2, standard)"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "standard"], var.root_volume_type)
    error_message = "Volume type must be one of: gp2, gp3, io1, io2, standard."
  }
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_volume_delete_on_termination" {
  description = "Whether to delete the root volume when the instance is terminated"
  type        = bool
  default     = true
}

# 추가 EBS 볼륨 설정
variable "additional_ebs_volumes" {
  description = "List of additional EBS volumes to attach"
  type = list(object({
    device_name           = string
    size                  = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
    tags                  = map(string)
  }))
  default = []
}

# 네트워크 설정
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "private_ip" {
  description = "Private IP address to associate with the instance"
  type        = string
  default     = null
}

# SSH 키 설정
variable "key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string
  default     = null
}

# 인스턴스 설정
variable "disable_api_termination" {
  description = "Whether to disable API termination of the instance"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance (stop or terminate)"
  type        = string
  default     = "stop"
  validation {
    condition     = contains(["stop", "terminate"], var.instance_initiated_shutdown_behavior)
    error_message = "Shutdown behavior must be either 'stop' or 'terminate'."
  }
}

variable "monitoring" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
}

# 사용자 데이터 설정
variable "user_data" {
  description = "User data script content (base64 encoded). Use filebase64() function to encode the file."
  type        = string
  default     = null
  sensitive   = true
}

variable "user_data_replace_on_change" {
  description = "Whether to replace the instance when user data changes"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
}
