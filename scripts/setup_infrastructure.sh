#!/bin/bash

# Variables
APP_ID="dole2coul5w42"
REGION="us-east-1"
DB_IDENTIFIER="macro-meal-planner"

echo "Setting up AWS infrastructure..."

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
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER

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
    --dimensions Name=DBInstanceIdentifier,Value=$DB_IDENTIFIER

# Configure Amplify app
echo "Configuring Amplify app..."
aws amplify update-app \
    --app-id $APP_ID \
    --name "Macro Meal Planner" \
    --description "A meal planning application" \
    --platform WEB \
    --auto-branch-creation-patterns '["feature/*", "dev/*"]' \
    --enable-branch-auto-build

# Configure branches
echo "Configuring branches..."
aws amplify update-branch \
    --app-id $APP_ID \
    --branch-name main \
    --framework "Next.js - SSR" \
    --stage PRODUCTION

aws amplify update-branch \
    --app-id $APP_ID \
    --branch-name develop \
    --framework "Next.js - SSR" \
    --stage DEVELOPMENT

echo "Infrastructure setup complete!"
echo "App URL: https://$APP_ID.amplifyapp.com"
