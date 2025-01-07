#!/bin/bash

echo "Configuring AWS CLI..."

# Get AWS credentials
read -p "Enter AWS Access Key ID: " aws_access_key_id
read -p "Enter AWS Secret Access Key: " aws_secret_access_key

# Configure AWS CLI
aws configure set aws_access_key_id "$aws_access_key_id"
aws configure set aws_secret_access_key "$aws_secret_access_key"
aws configure set default.region "us-east-1"
aws configure set default.output "json"

echo "AWS CLI configuration complete!"

# Test configuration
echo "Testing AWS configuration..."
aws sts get-caller-identity
