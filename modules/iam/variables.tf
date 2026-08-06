variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

variable "bucket_name" {
  description = "Private S3 bucket containing the website image"
  type        = string
}
