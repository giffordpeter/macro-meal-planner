#!/bin/bash

# Variables
DB_IDENTIFIER="macro-meal-planner"
REGION="us-east-1"

echo "Setting up monitoring infrastructure..."

# Set up CloudWatch alarms for RDS
echo "Setting up RDS monitoring..."

# CPU Utilization Alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "RDS-HighCPU" \
    --alarm-description "CPU utilization has exceeded 80%" \
    --metric-name CPUUtilization \
    --namespace AWS/RDS \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2 \
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER \
    --alarm-actions arn:aws:sns:$REGION:$(aws sts get-caller-identity --query 'Account' --output text):alerts

# Storage Space Alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "RDS-LowStorage" \
    --alarm-description "Free storage space is below 5GB" \
    --metric-name FreeStorageSpace \
    --namespace AWS/RDS \
    --statistic Average \
    --period 300 \
    --threshold 5000000000 \
    --comparison-operator LessThanThreshold \
    --evaluation-periods 1 \
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER \
    --alarm-actions arn:aws:sns:$REGION:$(aws sts get-caller-identity --query 'Account' --output text):alerts

# Database Connections Alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "RDS-HighConnections" \
    --alarm-description "Database connections have exceeded 80% of maximum" \
    --metric-name DatabaseConnections \
    --namespace AWS/RDS \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2 \
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER \
    --alarm-actions arn:aws:sns:$REGION:$(aws sts get-caller-identity --query 'Account' --output text):alerts

echo "Monitoring setup complete!"
echo "CloudWatch alarms have been created for:"
echo "- High CPU Usage"
echo "- Low Storage Space"
echo "- High Database Connections"
