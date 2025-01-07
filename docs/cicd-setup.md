# CI/CD Setup Documentation

## Overview
The Macro Meal Planner application uses GitHub Actions for CI/CD, deploying to AWS Amplify for hosting and AWS RDS for the database.

## Required Secrets
The following secrets need to be configured in GitHub repository settings:

### AWS Credentials
- `AWS_ACCESS_KEY_ID`: AWS IAM user access key
- `AWS_SECRET_ACCESS_KEY`: AWS IAM user secret key
- `AWS_AMPLIFY_APP_ID`: AWS Amplify application ID

### Database Configuration
- `TEST_DATABASE_URL`: Connection string for test database
- `PRODUCTION_DATABASE_URL`: Connection string for production database

### Authentication
- `NEXTAUTH_SECRET`: Secret for NextAuth.js
- `PRODUCTION_NEXTAUTH_URL`: Production URL for NextAuth.js
- `AUTH_GITHUB_ID`: GitHub OAuth application ID
- `AUTH_GITHUB_SECRET`: GitHub OAuth application secret

### API Keys
- `OPENAI_API_KEY`: OpenAI API key for AI features

## AWS Setup Requirements

### IAM User Permissions
The IAM user needs the following permissions:
- `amplify:StartJob`
- `amplify:DeleteBranch`
- `s3:PutObject`
- `s3:GetObject`

### S3 Bucket
- Create an S3 bucket named `macro-meal-planner-artifacts`
- Configure bucket policy for build artifacts

### Amplify Configuration
1. Create an Amplify app
2. Configure build settings:
   ```yaml
   version: 1
   frontend:
     phases:
       preBuild:
         commands:
           - npm ci
       build:
         commands:
           - npm run build
     artifacts:
       baseDirectory: out
       files:
         - '**/*'
     cache:
       paths:
         - node_modules/**/*
   ```

## Workflow Details

### Main Branch Deployment
1. Checkout code
2. Configure AWS credentials
3. Install dependencies
4. Run tests
5. Build application
6. Deploy to AWS Amplify

### Pull Request Workflow
1. Creates preview environment
2. Runs tests
3. Builds application
4. Deploys to preview URL
5. Cleans up environment on PR close

## Local Development
- Use `.env.development` for local development
- Use `.env.test` for running tests locally
- Never commit environment files

## Monitoring
- AWS CloudWatch for logs and metrics
- GitHub Actions for build status
- Amplify Console for deployment status

## Troubleshooting

### Common Issues
1. Build failures
   - Check Node.js version
   - Verify environment variables
   - Check dependency installation

2. Deployment failures
   - Verify AWS credentials
   - Check Amplify app configuration
   - Verify S3 bucket permissions

### Support
For issues:
1. Check CloudWatch logs
2. Review GitHub Actions logs
3. Check Amplify Console
4. Contact AWS support if needed
