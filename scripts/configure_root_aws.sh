#!/bin/bash

echo "Configuring AWS CLI with root/admin credentials..."

# Prompt for credentials
echo "Please enter your AWS admin credentials:"
read -p "AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -s -p "AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
echo
read -p "AWS Region [us-east-1]: " AWS_REGION
AWS_REGION=${AWS_REGION:-us-east-1}

# Configure AWS CLI
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set region "$AWS_REGION"
aws configure set output json

echo -e "\nAWS CLI configuration complete!"
echo "Testing AWS configuration..."

# Test the configuration
if aws sts get-caller-identity; then
    echo -e "\nConfiguration successful! Testing permissions..."
    
    # Test administrative access
    if aws iam list-users &>/dev/null; then
        echo "✅ Administrative access confirmed"
    else
        echo "❌ Warning: Current credentials don't have administrative access"
        echo "Please ensure you're using credentials from an IAM user with AdministratorAccess policy"
        exit 1
    fi
else
    echo "❌ Error: Failed to validate AWS credentials"
    exit 1
fi
