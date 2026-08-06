# ACS730 Final Project

Two-tier web application automation with Terraform.

## Branching Strategy

- `main`: Used for active development of the Terraform configuration.
- `staging`: Used to test completed changes and run GitHub Actions security scans.
- `prod`: Contains the final production-ready configuration and is protected from direct changes.

## Git Flow

1. Develop and commit changes to the `main` branch.
2. Merge completed changes from `main` into `staging`.
3. Run security scans automatically on pushes to `staging`.
4. Create a pull request from `staging` into `prod`.
5. Merge into `prod` only after the security scan passes.

## Naming Convention

Resources will use Camel case and include the project name and environment where possible.

Naming format:

`ACS730-<Environment>-<Resource>`

Examples:

- `ACS730-Dev-VPC`
- `ACS730-Staging-ALB`
- `ACS730-Prod-ASG`

The supported environments are:

- `Dev`
- `Staging`
- `Prod`

## Tagging Strategy

All supported AWS resources will use the following tags:

- `Name`: Descriptive resource name
- `Project`: `ACS730-Final-Project`
- `Environment`: `Dev`, `Staging`, or `Prod`
- `Owner`: `Daniel-Araujo`
- `ManagedBy`: `Terraform`
