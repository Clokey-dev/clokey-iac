variable "security_group_name" {
  description = "Name of security group"
  type = string
}

variable "environment" {
  description = "Environment name (ex: dev or prod)"
  type        = string
}

variable "purpose" {
  description = "Usage purpose (ex: jenkins, db, bastion)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "ingress_rules" {
  description = "Inbounds rule list"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    use_cidr                 = bool
    use_sg                   = bool
    cidr_blocks              = optional(list(string), [])
    source_security_group_id = optional(string)
  }))
}

variable "egress_rules" {
  description = "Outbounds rule list"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
