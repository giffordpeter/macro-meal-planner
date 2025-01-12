#!/bin/bash

# Exit on error
set -e

# Variables
REGION="us-east-1"
APP_ID="dole2coul5w42"
BUDGET_AMOUNT="50.00"
SNS_TOPIC_NAME="cost-alerts"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "Setting up cost monitoring..."

# Create SNS topic for cost alerts if it doesn't exist
SNS_TOPIC_ARN=$(aws sns create-topic --name $SNS_TOPIC_NAME --query 'TopicArn' --output text)

# Create budget for Amplify app
aws budgets create-budget \
    --account-id $ACCOUNT_ID \
    --budget '{
        "BudgetName": "macro-meal-planner-budget",
        "BudgetLimit": {
            "Amount": "'$BUDGET_AMOUNT'",
            "Unit": "USD"
        },
        "TimeUnit": "MONTHLY",
        "BudgetType": "COST",
        "CostFilters": {
            "TagKeyValue": ["user:Project$macro-meal-planner"]
        }
    }' \
    --notifications-with-subscribers '[
        {
            "Notification": {
                "NotificationType": "ACTUAL",
                "ComparisonOperator": "GREATER_THAN",
                "Threshold": 80,
                "ThresholdType": "PERCENTAGE"
            },
            "Subscribers": [
                {
                    "SubscriptionType": "SNS",
                    "Address": "'$SNS_TOPIC_ARN'"
                }
            ]
        },
        {
            "Notification": {
                "NotificationType": "FORECASTED",
                "ComparisonOperator": "GREATER_THAN",
                "Threshold": 100,
                "ThresholdType": "PERCENTAGE"
            },
            "Subscribers": [
                {
                    "SubscriptionType": "SNS",
                    "Address": "'$SNS_TOPIC_ARN'"
                }
            ]
        }
    ]'

# Create cost allocation tags
aws tag-resources \
    --resource-arn-list "arn:aws:amplify:$REGION:$ACCOUNT_ID:apps/$APP_ID" \
    --tags Project=macro-meal-planner,Environment=production

# Create CloudWatch dashboard for cost monitoring
aws cloudwatch put-dashboard \
    --dashboard-name "MacroMealPlannerCosts" \
    --dashboard-body '{
        "widgets": [
            {
                "type": "metric",
                "properties": {
                    "metrics": [
                        ["AWS/Billing", "EstimatedCharges", "ServiceName", "AWSAmplify", "Project", "macro-meal-planner"],
                        ["AWS/Billing", "EstimatedCharges", "ServiceName", "AmazonRDS", "Project", "macro-meal-planner"],
                        ["AWS/Billing", "EstimatedCharges", "ServiceName", "AWSLambda", "Project", "macro-meal-planner"]
                    ],
                    "period": 21600,
                    "stat": "Maximum",
                    "region": "us-east-1",
                    "title": "Estimated Monthly Charges by Service"
                }
            }
        ]
    }'

echo "Cost monitoring setup complete!"
