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
