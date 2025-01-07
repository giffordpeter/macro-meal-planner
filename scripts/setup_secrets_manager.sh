#!/bin/bash

# Variables
STAGING_SECRET_NAME="macro-meal-planner/staging"
PROD_SECRET_NAME="macro-meal-planner/production"
REGION="us-east-1"

# Create staging secrets
echo "Creating staging secrets..."
aws secretsmanager create-secret \
    --name $STAGING_SECRET_NAME \
    --description "Staging environment secrets for Macro Meal Planner" \
    --secret-string '{
        "DATABASE_URL": "postgresql://your-staging-host:5432/macro_meal_planner_staging",
        "NEXTAUTH_SECRET": "staging-secret-key",
        "AUTH_GITHUB_ID": "staging-github-client-id",
        "AUTH_GITHUB_SECRET": "staging-github-client-secret",
        "OPENAI_API_KEY": "staging-openai-key"
    }' \
    --tags Key=Environment,Value=staging Key=Project,Value=macro-meal-planner

# Create production secrets
echo "Creating production secrets..."
aws secretsmanager create-secret \
    --name $PROD_SECRET_NAME \
    --description "Production environment secrets for Macro Meal Planner" \
    --secret-string '{
        "DATABASE_URL": "postgresql://your-production-host:5432/macro_meal_planner_production",
        "NEXTAUTH_SECRET": "prod-secret-key",
        "AUTH_GITHUB_ID": "prod-github-client-id",
        "AUTH_GITHUB_SECRET": "prod-github-client-secret",
        "OPENAI_API_KEY": "prod-openai-key"
    }' \
    --tags Key=Environment,Value=production Key=Project,Value=macro-meal-planner

# Configure automatic rotation (optional)
echo "Configuring secret rotation..."
aws secretsmanager rotate-secret \
    --secret-id $STAGING_SECRET_NAME \
    --rotation-rules "{\"AutomaticallyAfterDays\": 30}"

aws secretsmanager rotate-secret \
    --secret-id $PROD_SECRET_NAME \
    --rotation-rules "{\"AutomaticallyAfterDays\": 30}"

echo "Secrets Manager setup completed!"
echo "Staging secret ARN: $STAGING_SECRET_NAME"
echo "Production secret ARN: $PROD_SECRET_NAME"
echo ""
echo "Next steps:"
echo "1. Update the actual secret values using the AWS Console or CLI"
echo "2. Configure the application to use Secrets Manager"
echo "3. Set up IAM roles for accessing secrets"
