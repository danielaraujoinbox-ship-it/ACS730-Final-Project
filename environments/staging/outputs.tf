output "website_url" {
  description = "URL used to access the Dev website"
  value       = "http://${module.alb.alb_dns_name}"
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.alb.alb_dns_name
}

output "bastion_public_ip" {
  description = "Public IP address of the Dev bastion host"
  value       = module.asg.bastion_public_ip
}

output "autoscaling_group_name" {
  description = "Dev Auto Scaling Group name"
  value       = module.asg.autoscaling_group_name
}

output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.network.vpc_id
}
