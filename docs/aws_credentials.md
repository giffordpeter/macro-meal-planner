# AWS Credentials Management Guide

## Creating New AWS Access Keys

1. Sign in to the AWS Management Console
2. Click on your username at the top right corner
3. Select "Security credentials"
4. Under "Access keys", click "Create access key"
5. Follow the prompts and make sure to:
   - Download the CSV file containing your credentials
   - Store the CSV file securely (e.g., in a password manager)
   - Never commit these credentials to version control

## Required Permissions

The IAM user needs these permissions:
- `AWSAmplifyAdmin`: For managing Amplify applications
- `AmazonRDSFullAccess`: For managing RDS instances
- `AmazonS3FullAccess`: For managing build artifacts
- `CloudWatchFullAccess`: For monitoring
- `SecretsManagerFullAccess`: For managing secrets

## Credential Storage

Store your AWS credentials in these locations:
1. Local AWS CLI configuration (~/.aws/credentials)
2. GitHub repository secrets (for CI/CD)
3. Password manager or secure credential storage

## Security Best Practices

1. Rotate access keys every 90 days
2. Never share access keys
3. Use separate keys for development and production
4. Monitor AWS CloudTrail for credential usage
5. Enable MFA for your AWS account

## Emergency Steps

If credentials are compromised:
1. Immediately deactivate the compromised access key
2. Create new access keys
3. Update all services using the old keys
4. Review AWS CloudTrail for unauthorized activity
