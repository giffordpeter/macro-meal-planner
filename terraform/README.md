# Terraform Infrastructure

This directory contains the Terraform configurations for the Macro Meal Planner infrastructure.

## Directory Structure

```
terraform/
├── environments/           # Environment-specific configurations
│   ├── staging/           # Staging environment
│   └── production/        # Production environment
├── modules/               # Reusable Terraform modules
│   ├── vpc/              # VPC module
│   ├── database/         # Aurora Serverless module
│   └── ecs/              # ECS Fargate module
└── shared/               # Shared configurations and backends
```

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Select workspace:
```bash
terraform workspace select [staging|production]
```

3. Plan changes:
```bash
terraform plan -var-file=environments/[staging|production]/terraform.tfvars
```

4. Apply changes:
```bash
terraform apply -var-file=environments/[staging|production]/terraform.tfvars
```
