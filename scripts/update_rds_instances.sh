#!/bin/bash

# Exit on error
set -e

# Variables
OLD_INSTANCE_ID="macro-meal-planner-db"
NEW_PROD_INSTANCE_ID="macro-meal-planner-prod"
REGION="us-east-1"

echo "Starting RDS instance updates..."

# 1. Get the current endpoint for reference
CURRENT_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $OLD_INSTANCE_ID \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)

echo "Current endpoint: $CURRENT_ENDPOINT"

# 2. Rename the instance
echo "Renaming instance to $NEW_PROD_INSTANCE_ID..."
aws rds modify-db-instance \
    --db-instance-identifier $OLD_INSTANCE_ID \
    --new-db-instance-identifier $NEW_PROD_INSTANCE_ID \
    --apply-immediately

# 3. Wait for the old instance to complete modification
echo "Waiting for rename to complete..."
aws rds wait db-instance-available \
    --db-instance-identifier $OLD_INSTANCE_ID

# Small pause to allow AWS to complete the rename
echo "Waiting for AWS to complete the rename..."
sleep 30

# 4. Add production tags
echo "Adding production tags..."
aws rds add-tags-to-resource \
    --resource-name "arn:aws:rds:$REGION:$(aws sts get-caller-identity --query Account --output text):db:$NEW_PROD_INSTANCE_ID" \
    --tags \
        "Key=Environment,Value=production" \
        "Key=Project,Value=macro-meal-planner" \
        "Key=ManagedBy,Value=terraform"

# 5. Get the new endpoint
NEW_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $NEW_PROD_INSTANCE_ID \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)

echo "RDS instance updates completed!"
echo "New production endpoint: $NEW_ENDPOINT"
echo ""
echo "Next steps:"
echo "1. Update the production environment file with the new endpoint"
echo "2. Deploy the updated configuration"
echo "3. Verify database connectivity"
