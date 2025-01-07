#!/bin/bash

# Variables
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query 'Vpcs[0].VpcId' --output text)
DB_INSTANCE_IDENTIFIER="macro-meal-planner-staging"

# Create security group for RDS
echo "Creating RDS security group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name "macro-meal-planner-staging-rds" \
    --description "Security group for Macro Meal Planner staging RDS" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)

# Add inbound rule for PostgreSQL
echo "Adding inbound rule for PostgreSQL..."
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 5432 \
    --source-group $SECURITY_GROUP_ID

# Modify RDS instance to use the new security group
echo "Updating RDS instance security group..."
aws rds modify-db-instance \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --vpc-security-group-ids $SECURITY_GROUP_ID \
    --apply-immediately

echo "Security group configuration complete!"
echo "Security Group ID: $SECURITY_GROUP_ID"
echo "Next steps:"
echo "1. Add additional inbound rules for your application servers"
echo "2. Update your application security group to allow outbound traffic to RDS"
