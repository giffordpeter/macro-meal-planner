#!/bin/bash

# Exit on error
set -e

# Default environment
ENV=${1:-staging}
REGION=${AWS_REGION:-us-east-1}
APP_NAME="macro-meal-planner"

# Validate environment
if [[ ! "$ENV" =~ ^(staging|production)$ ]]; then
    echo "Error: Environment must be 'staging' or 'production'"
    exit 1
fi

# Function to generate a secure random string
generate_secret() {
    openssl rand -base64 32
}

# Load template
TEMPLATE_FILE="scripts/env-templates/$ENV.env.template"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file $TEMPLATE_FILE not found"
    exit 1
fi

echo "Setting up $ENV environment..."

# Generate secrets
DB_PASSWORD=$(generate_secret)
NEXTAUTH_SECRET=$(generate_secret)

# Prompt for required values
read -p "Enter GitHub Client ID: " GITHUB_CLIENT_ID
read -p "Enter GitHub Client Secret: " GITHUB_CLIENT_SECRET
read -p "Enter OpenAI API Key: " OPENAI_API_KEY

# Create temporary env file
TMP_ENV_FILE=".env.$ENV.tmp"
cp "$TEMPLATE_FILE" "$TMP_ENV_FILE"

# Replace placeholders
sed -i '' "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" "$TMP_ENV_FILE"
sed -i '' "s/{{GITHUB_CLIENT_ID}}/$GITHUB_CLIENT_ID/g" "$TMP_ENV_FILE"
sed -i '' "s/{{GITHUB_CLIENT_SECRET}}/$GITHUB_CLIENT_SECRET/g" "$TMP_ENV_FILE"
sed -i '' "s/{{GENERATED_SECRET}}/$NEXTAUTH_SECRET/g" "$TMP_ENV_FILE"
sed -i '' "s/{{OPENAI_API_KEY}}/$OPENAI_API_KEY/g" "$TMP_ENV_FILE"

# Upload to Parameter Store
echo "Uploading parameters to AWS Parameter Store..."
source ./scripts/setup-parameter-store.sh "$ENV"

# Clean up
rm "$TMP_ENV_FILE"

echo "Environment setup complete for $ENV!"
echo "Parameters have been stored in AWS Parameter Store under /$APP_NAME/$ENV/"
