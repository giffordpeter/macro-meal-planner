#!/bin/bash

# Exit on error
set -e

# Variables
REGION="us-east-1"
DB_INSTANCE_IDENTIFIER="macro-meal-planner-test"
DB_MASTER_USERNAME="test_user"
DB_MASTER_PASSWORD="$(openssl rand -base64 32)"
DB_NAME="macro_meal_planner_test"

echo "Setting up test database..."

# Create RDS instance
aws rds create-db-instance \
    --db-instance-identifier "$DB_INSTANCE_IDENTIFIER" \
    --db-instance-class "db.t3.micro" \
    --engine "postgres" \
    --master-username "$DB_MASTER_USERNAME" \
    --master-user-password "$DB_MASTER_PASSWORD" \
    --allocated-storage 20 \
    --engine-version "15.10" \
    --no-publicly-accessible \
    --backup-retention-period 1 \
    --db-name "$DB_NAME" \
    --tags Key=Environment,Value=test

# Wait for the database to be available
echo "Waiting for database to be available..."
aws rds wait db-instance-available \
    --db-instance-identifier "$DB_INSTANCE_IDENTIFIER"

# Get the database endpoint
DB_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier "$DB_INSTANCE_IDENTIFIER" \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)

# Create the connection URL
DB_URL="postgresql://${DB_MASTER_USERNAME}:${DB_MASTER_PASSWORD}@${DB_ENDPOINT}:5432/${DB_NAME}"

# Store the database URL in Secrets Manager
aws secretsmanager create-secret \
    --name "macro-meal-planner/test/database-url" \
    --description "Test database URL for CI/CD" \
    --secret-string "$DB_URL"

echo "Test database setup completed!"
echo "Database URL stored in Secrets Manager as 'macro-meal-planner/test/database-url'"
