# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is the repository for the LinkedIn Learning course "Learning Terraform" by Josh Samuelson. It contains Terraform configurations for provisioning AWS infrastructure, specifically EC2 instances with Tomcat installed via Bitnami AMIs.

## Core Terraform Files
- `main.tf`: Defines the primary infrastructure resources including an AWS EC2 instance using a Bitnami Tomcat AMI
- `providers.tf`: Configures the AWS provider and required providers
- `variables.tf`: Contains commented-out variable definitions for configurable parameters
- `outputs.tf`: Contains commented-out output definitions for exposing resource attributes
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

## Architecture Overview
This is a simple Terraform project that demonstrates basic AWS infrastructure provisioning:

1. Uses the AWS provider to connect to AWS
2. Queries for the most recent Bitnami Tomcat AMI using a data source
3. Provisions a t3.nano EC2 instance with that AMI
4. Tags the instance as "HelloWorld"

The configuration follows Terraform best practices with separate files for providers, variables, and outputs, though many variables and outputs are currently commented out.

## Branch Structure
The repository contains branches corresponding to different stages of the LinkedIn Learning course:
- `main`: Starting code for the course
- `final`: Completed code for the course
- `CHAPTER#_MOVIE#`: Branches for each specific video in the course

## Development Considerations
- This repository does not accept pull requests (see CONTRIBUTING.md)
- The AWS region is hardcoded to us-west-2
- The instance type is hardcoded to t3.nano
- The AMI selection is filtered to Bitnami Tomcat images owned by account ID 979382823631