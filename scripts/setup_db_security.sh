#!/bin/bash

# Check AWS CLI installation
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first:"
    echo "brew install awscli"
    exit 1
fi

# Variables
REGION="us-east-1"
DB_IDENTIFIER="macro-meal-planner"
CONFIG_FILE="../aws/rds-security.json"

echo "Setting up RDS security configuration..."

# Create security group
echo "Creating security group..."
SG_ID=$(aws ec2 create-security-group \
    --group-name "rds-${DB_IDENTIFIER}" \
    --description "Security group for RDS PostgreSQL access" \
    --region $REGION \
    --output text \
    --query 'GroupId')

# Configure security group rules
echo "Configuring security group rules..."
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 5432 \
    --source-group $(aws amplify get-app --app-id dole2coul5w42 --query 'app.environmentVariables.AMPLIFY_SECURITY_GROUP' --output text) \
    --region $REGION

# Create IAM role
echo "Creating IAM role..."
aws iam create-role \
    --role-name "rds-${DB_IDENTIFIER}-access" \
    --assume-role-policy-document file://../aws/rds-security.json \
    --region $REGION

# Attach policy to role
echo "Attaching policy to role..."
aws iam put-role-policy \
    --role-name "rds-${DB_IDENTIFIER}-access" \
    --policy-name "RDSAccessPolicy" \
    --policy-document file://../aws/rds-security.json \
    --region $REGION

# Set up CloudWatch alarms
echo "Setting up CloudWatch alarms..."
aws cloudwatch put-metric-alarm \
    --alarm-name "${DB_IDENTIFIER}-high-cpu" \
    --alarm-description "Alarm when CPU exceeds 80%" \
    --metric-name CPUUtilization \
    --namespace AWS/RDS \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2 \
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER \
    --region $REGION

aws cloudwatch put-metric-alarm \
    --alarm-name "${DB_IDENTIFIER}-low-storage" \
    --alarm-description "Alarm when free storage space is low" \
    --metric-name FreeStorageSpace \
    --namespace AWS/RDS \
    --statistic Average \
    --period 300 \
    --threshold 5000000000 \
    --comparison-operator LessThanThreshold \
    --evaluation-periods 1 \
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER \
    --region $REGION

echo "Database security configuration complete!"
echo "Security Group ID: $SG_ID"
