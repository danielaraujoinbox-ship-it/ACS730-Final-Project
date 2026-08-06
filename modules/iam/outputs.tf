output "instance_profile_name" {
  description = "IAM instance profile assigned to EC2 instances"
  value       = aws_iam_instance_profile.ec2.name
}

output "role_name" {
  description = "IAM role assigned to EC2 instances"
  value       = aws_iam_role.ec2.name
}
