variable "admin_cidr" {
  description = "Public IP address allowed to SSH to the bastion host"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
