#!/bin/bash

# Exit on error and print commands
set -ex

# Default environment and API key
ENV=${1:-staging}
API_KEY=${2:-}
REGION=${AWS_REGION:-us-east-1}
APP_NAME="macro-meal-planner"

# Validate environment
if [[ ! "$ENV" =~ ^(staging|production)$ ]]; then
    echo "Error: Environment must be 'staging' or 'production'"
    exit 1
fi

# Validate API key
if [ -z "$API_KEY" ]; then
    echo "Error: OpenAI API key must be provided as second argument"
    echo "Usage: $0 <environment> <openai-api-key>"
    exit 1
fi

echo "Setting up $ENV environment..."

# Verify AWS credentials
echo "Verifying AWS credentials..."
aws sts get-caller-identity

# Set environment-specific values
if [ "$ENV" = "staging" ]; then
    echo "Configuring staging environment..."
    NEXTAUTH_URL="https://develop.dole2coul5w42.amplifyapp.com"
    DATABASE_URL="postgresql://app@macro-meal-planner-staging.c9aogqy0mcah.us-east-1.rds.amazonaws.com:5432/macro_meal_planner"
    AUTH_GITHUB_ID="Ov23lizRCSEvZwDl0ffz"
    AUTH_GITHUB_SECRET="ae5bedeffbb979964ccc9eb8f95cb62471e44317"
else
    echo "Configuring production environment..."
    NEXTAUTH_URL="https://main.dole2coul5w42.amplifyapp.com"
    DATABASE_URL="postgresql://app@macro-meal-planner-prod.c9aogqy0mcah.us-east-1.rds.amazonaws.com:5432/macro_meal_planner"
    AUTH_GITHUB_ID="Ov23ligojSUMNXaQZ1pg"
    AUTH_GITHUB_SECRET="925da9849e2ee3d61727ed584d5238235e92dd30"
fi

# Generate NextAuth secret
echo "Generating NextAuth secret..."
NEXTAUTH_SECRET=$(openssl rand -base64 32)
echo "NextAuth secret generated successfully"

# Set OpenAI API key
OPENAI_API_KEY="$API_KEY"

# Create parameters in AWS Parameter Store
echo "Uploading parameters to AWS Parameter Store..."

# Function to create/update a parameter
create_parameter() {
    local name=$1
    local value=$2
    local description=$3
    local type=${4:-SecureString}  # Default to SecureString for security

    echo "Creating/updating parameter: $name"
    aws ssm put-parameter \
        --name "$name" \
        --value "$value" \
        --type "$type" \
        --description "$description" \
        --overwrite \
        --region "$REGION" \
        --output json
}

# Base path for parameters
BASE_PATH="/$APP_NAME/$ENV"

echo "Creating parameters under $BASE_PATH"

# Create/update parameters
create_parameter \
    "$BASE_PATH/NEXTAUTH_URL" \
    "${NEXTAUTH_URL}" \
    "NextAuth URL for $ENV environment"

create_parameter \
    "$BASE_PATH/DATABASE_URL" \
    "${DATABASE_URL}" \
    "PostgreSQL connection string for $ENV environment"

create_parameter \
    "$BASE_PATH/AUTH_GITHUB_ID" \
    "${AUTH_GITHUB_ID}" \
    "GitHub OAuth Client ID"

create_parameter \
    "$BASE_PATH/AUTH_GITHUB_SECRET" \
    "${AUTH_GITHUB_SECRET}" \
    "GitHub OAuth Client Secret"

create_parameter \
    "$BASE_PATH/NEXTAUTH_SECRET" \
    "${NEXTAUTH_SECRET}" \
    "NextAuth secret key"

create_parameter \
    "$BASE_PATH/OPENAI_API_KEY" \
    "${OPENAI_API_KEY}" \
    "OpenAI API Key"

# Create non-secret parameters
create_parameter \
    "$BASE_PATH/NODE_ENV" \
    "$ENV" \
    "Node environment" \
    "String"

create_parameter \
    "$BASE_PATH/PORT" \
    "3000" \
    "Application port" \
    "String"

echo "Environment setup complete for $ENV!"

# List all parameters (without values) for verification
echo -e "\nVerifying parameters:"
aws ssm get-parameters-by-path \
    --path "$BASE_PATH" \
    --recursive \
    --query "Parameters[*].{Name:Name,Type:Type,LastModified:LastModifiedDate}" \
    --output table \
    --region "$REGION"
