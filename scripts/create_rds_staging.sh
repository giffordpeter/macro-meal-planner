#!/bin/bash

# Variables
DB_INSTANCE_IDENTIFIER="macro-meal-planner-staging"
DB_INSTANCE_CLASS="db.t3.micro"
DB_ENGINE="postgres"
DB_ENGINE_VERSION="15.10"
DB_NAME="macro_meal_planner_staging"
DB_USERNAME="mmp_staging_user"
DB_PORT="5432"
STORAGE_TYPE="gp2"
ALLOCATED_STORAGE="20"
BACKUP_RETENTION_PERIOD="1"

# Create the RDS instance
echo "Creating RDS instance..."
aws rds create-db-instance \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --db-instance-class $DB_INSTANCE_CLASS \
    --engine $DB_ENGINE \
    --engine-version $DB_ENGINE_VERSION \
    --master-username $DB_USERNAME \
    --master-user-password "REPLACE_WITH_SECURE_PASSWORD" \
    --allocated-storage $ALLOCATED_STORAGE \
    --storage-type $STORAGE_TYPE \
    --backup-retention-period $BACKUP_RETENTION_PERIOD \
    --no-publicly-accessible \
    --db-name $DB_NAME \
    --port $DB_PORT \
    --enable-performance-insights \
    --tags Key=Environment,Value=staging

# Wait for the instance to be available
echo "Waiting for RDS instance to be available..."
aws rds wait db-instance-available \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER

# Get the endpoint
echo "Getting RDS endpoint..."
ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --query 'DBInstances[0].Endpoint.Address' \
    --output text)

echo "RDS instance created successfully!"
echo "Endpoint: $ENDPOINT"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"
echo "Username: $DB_USERNAME"
echo "Next steps:"
echo "1. Update the security group to allow access from your application"
echo "2. Update the .env.staging file with the new connection string"
echo "3. Run database migrations"
