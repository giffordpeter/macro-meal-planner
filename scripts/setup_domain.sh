#!/bin/bash

# Check if AWS CLI is installed and configured
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first:"
    echo "brew install awscli"
    exit 1
fi

# Variables
APP_ID="dole2coul5w42"
DOMAIN="dole2coul5w42.amplifyapp.com"
REGION="us-east-1"

echo "Setting up branch configurations for AWS Amplify app..."

# Configure main branch
aws amplify update-branch \
    --app-id $APP_ID \
    --branch-name main \
    --framework "Next.js - SSR" \
    --stage PRODUCTION \
    --region $REGION

# Configure develop branch
aws amplify update-branch \
    --app-id $APP_ID \
    --branch-name develop \
    --framework "Next.js - SSR" \
    --stage DEVELOPMENT \
    --region $REGION

echo "Branch configuration complete!"
echo "Your app will be available at:"
echo "Main branch: https://$DOMAIN"
echo "Develop branch: https://dev.$DOMAIN"
