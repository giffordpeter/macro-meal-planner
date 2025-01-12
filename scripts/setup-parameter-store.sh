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
        --region "$REGION"
}

# Base path for parameters
BASE_PATH="/$APP_NAME/$ENV"

echo "Setting up parameters for $ENV environment..."

# Load environment variables from .env file if it exists
ENV_FILE=".env.$ENV"
if [ -f "$ENV_FILE" ]; then
    echo "Loading variables from $ENV_FILE"
    source "$ENV_FILE"
else
    echo "Warning: $ENV_FILE not found"
fi

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

echo "Parameter Store setup complete for $ENV environment!"

# List all parameters (without values) for verification
echo -e "\nVerifying parameters:"
aws ssm get-parameters-by-path \
    --path "$BASE_PATH" \
    --recursive \
    --query "Parameters[*].Name" \
    --output table \
    --region "$REGION"
