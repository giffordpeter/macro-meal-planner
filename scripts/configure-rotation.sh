#!/bin/bash

# Check if required environment variables are set
required_vars=("AWS_REGION" "AWS_ACCOUNT_ID" "ENVIRONMENT")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Required environment variable $var is not set"
        exit 1
    fi
done

# Set up ARNs based on environment variables
ROTATION_LAMBDA_ARN="arn:aws:lambda:${AWS_REGION}:${AWS_ACCOUNT_ID}:function:macro-meal-planner-${ENVIRONMENT}-secret-rotation"
ALERT_TOPIC_ARN="arn:aws:sns:${AWS_REGION}:${AWS_ACCOUNT_ID}:secret-rotation-alerts-${ENVIRONMENT}"

# Create temporary config file with actual ARNs
temp_config=$(mktemp)
sed \
    -e "s|\${ROTATION_LAMBDA_ARN}|${ROTATION_LAMBDA_ARN}|g" \
    -e "s|\${ALERT_TOPIC_ARN}|${ALERT_TOPIC_ARN}|g" \
    aws/lambda/secret-rotation/rotation-config.json > "$temp_config"

# Apply the configuration
aws secretsmanager update-secret-rotation-configuration \
    --secret-id "macro-meal-planner/${ENVIRONMENT}/database" \
    --cli-input-json "file://${temp_config}"

# Clean up
rm "$temp_config"
