locals {
  project_name = "ACS730-Final-Project"
  environment  = "Dev"
  owner        = "Daniel-Araujo"
}

module "network" {
  source = "../../modules/network"

  project_name = local.project_name
  environment  = local.environment
  owner        = local.owner

  vpc_cidr = "10.100.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  public_subnet_cidrs = [
    "10.100.1.0/24",
    "10.100.2.0/24",
    "10.100.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.100.11.0/24",
    "10.100.12.0/24",
    "10.100.13.0/24"
  ]
}

module "security" {
  source = "../../modules/security"

  project_name = local.project_name
  environment  = local.environment
  owner        = local.owner
  vpc_id       = module.network.vpc_id
  admin_cidr   = var.admin_cidr
}

module "iam" {
  source = "../../modules/iam"

  project_name = local.project_name
  environment  = local.environment
  owner        = local.owner
  bucket_name  = "acs730-dev-daniel009"
}

module "alb" {
  source = "../../modules/alb"

  project_name          = local.project_name
  environment           = local.environment
  owner                 = local.owner
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}

module "asg" {
  source = "../../modules/asg"

  project_name = local.project_name
  environment  = local.environment
  owner        = local.owner

  instance_type    = "t3.micro"
  desired_capacity = 2
  minimum_capacity = 1
  maximum_capacity = 4

  key_name    = "ACS730-Project-Key"
  bucket_name = "acs730-dev-daniel009"

  public_subnet_id   = module.network.public_subnet_ids[0]
  private_subnet_ids = module.network.private_subnet_ids

  bastion_security_group_id = module.security.bastion_security_group_id
  web_security_group_id     = module.security.web_security_group_id
  instance_profile_name     = module.iam.instance_profile_name
  target_group_arn          = module.alb.target_group_arn
}
