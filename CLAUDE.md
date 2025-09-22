# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform infrastructure project for creating a custom VPC in AWS. The project sets up a basic VPC with public and private subnets and an internet gateway.

## Architecture

The infrastructure is defined across 4 main Terraform files:

- `main.tf` - Core VPC resource definitions including VPC, subnets, and internet gateway
- `provider.tf` - AWS provider configuration with region and authentication settings
- `vars.tf` - Variable declarations for AWS region, credentials, and network CIDR blocks
- `README.md` - Basic project documentation

### Key Resources

- **VPC**: `aws_vpc.llptest-aws-vpc` - Main VPC with DNS support and hostnames enabled
- **Public Subnet**: `aws_subnet.public_subnet` - Public subnet within the VPC
- **Private Subnet**: `aws_subnet.private_subnet` - Private subnet within the VPC
- **Internet Gateway**: `aws_internet_gateway.llp_test_igw` - Provides internet access

## Common Commands

This is a standard Terraform project. Use these commands for development and deployment:

```bash
# Initialize Terraform (download providers)
terraform init

# Plan infrastructure changes
terraform plan

# Apply infrastructure changes
terraform apply

# Destroy all infrastructure
terraform destroy

# Format Terraform files
terraform fmt

# Validate Terraform configuration
terraform validate
```

## Configuration

Variables must be set for:
- `aws_vpc_cidr_block` - CIDR block for the VPC
- `aws_public_subnet_cidr` - CIDR block for public subnet
- `aws_private_subnet_cidr` - CIDR block for private subnet
- `aws_access_key` and `aws_secret_key` - AWS credentials (defaults to empty)
- `aws_region` - AWS region (defaults to us-east-1)

The provider is configured for AWS account ID `590184034896`.

## Security Notes

- AWS credentials are defined as variables in `vars.tf` with empty defaults
- The provider configuration references these credentials via variables
- Ensure proper AWS authentication is configured before running Terraform commands