#!/bin/bash

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI is not installed. Please install it first:"
    echo "brew install gh"
    exit 1
fi

# Check if logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo "Please login to GitHub CLI first:"
    echo "gh auth login"
    exit 1
fi

# Function to set a secret
set_secret() {
    local secret_name=$1
    local default_value=$2
    
    echo "Setting $secret_name..."
    if [ -z "$default_value" ]; then
        read -p "Enter value for $secret_name: " secret_value
    else
        secret_value=$default_value
    fi
    
    echo "$secret_value" | gh secret set "$secret_name"
}

echo "Setting up GitHub repository secrets..."

# AWS Credentials
set_secret "AWS_ACCESS_KEY_ID"
set_secret "AWS_SECRET_ACCESS_KEY"
set_secret "AWS_AMPLIFY_APP_ID" "dole2coul5w42"
set_secret "AWS_REGION" "us-east-1"

# Database Configuration
set_secret "TEST_DATABASE_URL"
set_secret "PRODUCTION_DATABASE_URL"

# Authentication
NEXTAUTH_SECRET=$(openssl rand -base64 32)
set_secret "NEXTAUTH_SECRET" "$NEXTAUTH_SECRET"
set_secret "PRODUCTION_NEXTAUTH_URL" "https://dole2coul5w42.amplifyapp.com"
set_secret "AUTH_GITHUB_ID"
set_secret "AUTH_GITHUB_SECRET"

# API Keys
set_secret "OPENAI_API_KEY"

echo "All secrets have been set!"
