output "instance_profile_name" {
  description = "Existing AWS Academy instance profile assigned to EC2"
  value       = data.aws_iam_instance_profile.lab.name
}

output "role_name" {
  description = "Role attached to the AWS Academy instance profile"
  value       = data.aws_iam_instance_profile.lab.role_name
}
