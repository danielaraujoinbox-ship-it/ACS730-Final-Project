variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "minimum_capacity" {
  type = number
}

variable "maximum_capacity" {
  type = number
}

variable "key_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "public_subnet_id" {
  description = "Public subnet used by the bastion host"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets used by the Auto Scaling Group"
  type        = list(string)
}

variable "bastion_security_group_id" {
  type = string
}

variable "web_security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}
