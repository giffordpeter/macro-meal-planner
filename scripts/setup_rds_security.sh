#!/bin/bash

DB_IDENTIFIER="macro-meal-planner"
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)

echo "Setting up RDS security..."
echo "Using VPC: $VPC_ID"

# Create security group
echo "Creating security group..."
SG_ID=$(aws ec2 create-security-group \
    --group-name "rds-${DB_IDENTIFIER}" \
    --description "Security group for RDS PostgreSQL access" \
    --vpc-id "$VPC_ID" \
    --output text \
    --query 'GroupId')

# Tag the security group
aws ec2 create-tags \
    --resources "$SG_ID" \
    --tags "Key=Name,Value=rds-${DB_IDENTIFIER}"

# Configure security group rules
echo "Configuring security group rules..."

# Allow PostgreSQL access from anywhere (for development)
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 5432 \
    --cidr "0.0.0.0/0"

# Update RDS instance to use the new security group
echo "Updating RDS instance security group..."
aws rds modify-db-instance \
    --db-instance-identifier "$DB_IDENTIFIER-db" \
    --vpc-security-group-ids "$SG_ID" \
    --apply-immediately

echo "Security setup complete!"
echo "Security Group ID: $SG_ID"
echo "Note: The RDS instance will be using the new security group shortly."
