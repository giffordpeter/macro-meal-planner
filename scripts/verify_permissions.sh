#!/bin/bash

echo "Verifying AWS credentials permissions..."

# Get current user/role
echo "Current identity:"
aws sts get-caller-identity

# Check IAM permissions
echo -e "\nChecking IAM permissions..."
aws iam get-user 2>/dev/null && echo "✅ Has IAM user access" || echo "❌ No IAM user access"
aws iam list-policies --scope AWS --max-items 1 2>/dev/null && echo "✅ Has IAM policy access" || echo "❌ No IAM policy access"

# Check EC2 permissions
echo -e "\nChecking EC2 permissions..."
aws ec2 describe-instances --max-items 1 2>/dev/null && echo "✅ Has EC2 read access" || echo "❌ No EC2 read access"
aws ec2 describe-security-groups --max-items 1 2>/dev/null && echo "✅ Has security group access" || echo "❌ No security group access"

# Check Amplify permissions
echo -e "\nChecking Amplify permissions..."
aws amplify list-apps 2>/dev/null && echo "✅ Has Amplify read access" || echo "❌ No Amplify read access"
aws amplify list-branches --app-id dole2coul5w42 2>/dev/null && echo "✅ Has Amplify branch access" || echo "❌ No Amplify branch access"

# Check RDS permissions
echo -e "\nChecking RDS permissions..."
aws rds describe-db-instances --max-items 1 2>/dev/null && echo "✅ Has RDS read access" || echo "❌ No RDS read access"

# Check CloudWatch permissions
echo -e "\nChecking CloudWatch permissions..."
aws cloudwatch list-metrics --max-items 1 2>/dev/null && echo "✅ Has CloudWatch read access" || echo "❌ No CloudWatch read access"

echo -e "\nPermission check complete!"
