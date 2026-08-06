variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "admin_cidr" {
  description = "CIDR permitted to connect to the bastion host using SSH"
  type        = string
}
