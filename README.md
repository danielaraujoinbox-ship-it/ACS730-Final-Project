# ACS730 Final Project

Two-tier AWS web application deployed using Terraform.

This project creates a highly available web application using AWS services including VPC, EC2, Application Load Balancer, Auto Scaling Group, IAM, and S3.

## Architecture

The infrastructure includes:

- VPC with public and private subnets
- Bastion host for SSH administration
- Application Load Balancer for distributing traffic
- Auto Scaling Group for managing EC2 web servers
- EC2 instances running the web application
- S3 bucket for storing application images
- IAM role allowing EC2 instances to access S3

## Terraform Environments

The project uses separate Terraform configurations for each environment:

- **Dev**: Main development and testing environment.
- **Staging**: Testing environment using the same reusable Terraform modules.
- **Prod**: Production configuration using the same infrastructure structure.

Each environment contains its own Terraform files:

- `main.tf`
- `variables.tf`
- `terraform.tfvars`
- `providers.tf`
- `outputs.tf`

## Terraform Deployment

Clone the repository:

```bash
git clone <repository-url>
```

Navigate to an environment:

```bash
cd environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Review the deployment plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

## Naming Convention

AWS resources follow the format:

```
ACS730-<Environment>-<Resource>
```

Examples:

```
ACS730-Dev-ALB
ACS730-Staging-ASG
ACS730-Prod-VPC
```

## Tagging Strategy

Resources are tagged with:

- `Name` - Resource name
- `Project` - ACS730-Final-Project
- `Environment` - Dev, Staging, or Prod
- `Owner` - Daniel-Araujo
- `ManagedBy` - Terraform

## High Availability

The application uses an Application Load Balancer and Auto Scaling Group to maintain availability.

If a web server becomes unavailable, Auto Scaling can replace the instance while the Load Balancer continues directing traffic to healthy servers.
