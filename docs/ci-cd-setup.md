# CI/CD Setup Documentation

## Overview
This document describes the CI/CD setup for the Macro Meal Planner project, including GitHub Actions workflows, branch protection rules, SSL certificates, and secret rotation.

## GitHub Actions Workflows

### Production Workflow
- Triggered on:
  - Push to main branch
  - Pull requests to main branch
- Environment: Production
- Steps:
  1. Build and test
  2. Deploy to AWS Amplify
  3. Run smoke tests

### Staging Workflow
- Triggered on:
  - Push to develop branch
  - Pull requests to develop branch
- Environment: Staging
- Steps:
  1. Build and test
  2. Deploy to staging
  3. Run integration tests

## Branch Protection Rules

### Main Branch
- Required reviews: 1
- Required status checks:
  - build_and_deploy
- Linear history required
- Force push disabled
- Branch deletion disabled
- Administrator enforcement enabled

### Develop Branch
- Required reviews: 1
- Required status checks:
  - build_and_deploy
- Force push allowed for CI
- Branch deletion disabled

## SSL Certificates

### Certificate Management
- AWS Certificate Manager (ACM)
- Domains:
  - Production: main.dole2coul5w42.amplifyapp.com
  - Staging: develop.dole2coul5w42.amplifyapp.com
- DNS validation
- Auto-renewal enabled

### Implementation
1. Request certificates using `request-certificates.sh`
2. Add DNS validation records
3. Verify with `validate-certificates.sh`
4. Associate with Amplify domains

## Secret Rotation

### Lambda Function
- Name: macro-meal-planner-secret-rotation
- Runtime: Python 3.9
- Memory: 128MB
- Timeout: 30 seconds
- Rotation steps:
  1. Create new secret
  2. Set secret in target system
  3. Test new secret
  4. Finalize rotation

### Monitoring
- CloudWatch dashboard: secret-rotation-monitoring
- Alarms:
  - Lambda errors
  - Lambda duration
  - Rotation failures
- SNS notifications
- 30-day rotation schedule

## Scripts

### Certificate Management
- `scripts/request-certificates.sh`: Request SSL certificates
- `scripts/validate-certificates.sh`: Validate and associate certificates

### Branch Protection
- `scripts/configure-branch-protection.sh`: Set up branch protection rules

### Secret Rotation
- `scripts/setup-secret-rotation.sh`: Deploy and configure rotation
- `scripts/setup-monitoring.sh`: Set up monitoring and alerts

## Troubleshooting

### SSL Certificates
1. Check certificate status in ACM console
2. Verify DNS records
3. Check Amplify domain settings

### Secret Rotation
1. Check CloudWatch logs
2. Verify IAM permissions
3. Check SNS notifications
4. Monitor rotation metrics

### CI/CD Pipeline
1. Check GitHub Actions logs
2. Verify environment variables
3. Check AWS Amplify console
4. Monitor deployment status
