# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is the repository for the LinkedIn Learning course "Learning Terraform" by Josh Samuelson. It contains Terraform configurations for provisioning AWS infrastructure, specifically EC2 instances with Tomcat installed via Bitnami AMIs.

## Core Terraform Files
- `main.tf`: Defines the primary infrastructure resources including an AWS EC2 instance using a Bitnami Tomcat AMI
- `providers.tf`: Configures the AWS provider and required providers
- `variables.tf`: Contains variable definitions for configurable parameters
- `outputs.tf`: Contains output definitions for exposing resource attributes
- `terraform.tfvars`: (Not present yet) Would contain variable values for deployments

## Common Development Commands
Initialize Terraform:
```bash
terraform init
```

Validate configuration syntax:
```bash
terraform validate
```

Format configuration files:
```bash
terraform fmt
```

Plan infrastructure changes:
```bash
terraform plan
```

Apply infrastructure changes:
```bash
terraform apply
```

Destroy infrastructure:
```bash
terraform destroy
```

## Git Workflow
When working with this repository, it's essential to maintain regular commits and pushes to GitHub:

1. Make frequent, small commits with descriptive messages
2. Push changes to GitHub regularly to avoid losing work
3. Use clear, concise commit messages that explain what changed and why
4. Commit syntax fixes, improvements, and new features separately for clarity

Example of a good commit message:
```
Fix syntax error in EC2 instance type variable reference

- Corrected malformed variable reference in main.tf
- Removed misplaced quotation mark from var.instance_type
```

## Architecture Overview
This is a simple Terraform project that demonstrates basic AWS infrastructure provisioning:

1. Uses the AWS provider to connect to AWS
2. Queries for the most recent Bitnami Tomcat AMI using a data source
3. Provisions a t3.micro EC2 instance with that AMI (updated from t3.nano)
4. Tags the instance as "HelloWorld"

The configuration follows Terraform best practices with separate files for providers, variables, and outputs.

## Branch Structure
The repository contains branches corresponding to different stages of the LinkedIn Learning course:
- `main`: Starting code for the course
- `final`: Completed code for the course
- `CHAPTER#_MOVIE#`: Branches for each specific video in the course

## Development Considerations
- This repository does not accept pull requests (see CONTRIBUTING.md)
- The AWS region is hardcoded to us-west-2
- The instance type uses a variable with default value t3.micro (updated from t3.nano)
- The AMI selection is filtered to Bitnami Tomcat images owned by account ID 979382823631
- All changes should be committed and pushed to GitHub regularly to maintain work progress