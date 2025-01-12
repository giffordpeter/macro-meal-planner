#!/bin/bash

# Exit on error
set -e

# Variables
REGION="us-east-1"
FUNCTION_NAME="macro-meal-planner-secret-rotation"
SNS_TOPIC_NAME="secret-rotation-alerts"
APP_ID="dole2coul5w42"  # From project_TechStack.md

echo "Setting up CloudWatch monitoring..."

# Get SNS topic ARN
SNS_TOPIC_ARN=$(aws sns list-topics --query 'Topics[?contains(TopicArn,`'$SNS_TOPIC_NAME'`)].TopicArn' --output text)

# Create CloudWatch alarm for Lambda errors
aws cloudwatch put-metric-alarm \
    --alarm-name "${FUNCTION_NAME}-errors" \
    --alarm-description "Alarm when the rotation function has errors" \
    --metric-name Errors \
    --namespace AWS/Lambda \
    --statistic Sum \
    --period 300 \
    --threshold 1 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1 \
    --dimensions Name=FunctionName,Value=$FUNCTION_NAME \
    --alarm-actions "$SNS_TOPIC_ARN"

# Create CloudWatch alarm for Lambda duration
aws cloudwatch put-metric-alarm \
    --alarm-name "${FUNCTION_NAME}-duration" \
    --alarm-description "Alarm when the rotation function takes too long" \
    --metric-name Duration \
    --namespace AWS/Lambda \
    --statistic Average \
    --period 300 \
    --threshold 10000 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1 \
    --dimensions Name=FunctionName,Value=$FUNCTION_NAME \
    --alarm-actions "$SNS_TOPIC_ARN"

# Create CloudWatch alarm for failed rotations
aws cloudwatch put-metric-alarm \
    --alarm-name "secret-rotation-failures" \
    --alarm-description "Alarm when secret rotation fails" \
    --metric-name RotationFailureCount \
    --namespace AWS/SecretsManager \
    --statistic Sum \
    --period 300 \
    --threshold 1 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1 \
    --alarm-actions "$SNS_TOPIC_ARN"

# Set up Amplify build monitoring
echo "Setting up Amplify build monitoring..."

# Create log group for Amplify builds if it doesn't exist
aws logs create-log-group --log-group-name "/aws/amplify/${APP_ID}/build" || true
aws logs put-retention-policy --log-group-name "/aws/amplify/${APP_ID}/build" --retention-in-days 30

# Create CloudWatch alarm for Amplify build failures
aws cloudwatch put-metric-alarm \
    --alarm-name "amplify-build-failures" \
    --alarm-description "Alarm when Amplify builds fail" \
    --metric-name BuildErrors \
    --namespace "MacroMealPlanner/Amplify" \
    --statistic Sum \
    --period 300 \
    --threshold 2 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2 \
    --dimensions Name=Environment,Value=Production Name=AppId,Value=${APP_ID} \
    --alarm-actions "$SNS_TOPIC_ARN"

# Create CloudWatch alarm for high API error rate
aws cloudwatch put-metric-alarm \
    --alarm-name "high-api-error-rate" \
    --alarm-description "Alarm when API error rate is high" \
    --metric-name APIErrors \
    --namespace "MacroMealPlanner/API" \
    --statistic Sum \
    --period 300 \
    --threshold 10 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 3 \
    --dimensions Name=Environment,Value=Production Name=AppId,Value=${APP_ID} \
    --alarm-actions "$SNS_TOPIC_ARN"

# Create CloudWatch dashboard
aws cloudwatch put-dashboard \
    --dashboard-name "secret-rotation-monitoring" \
    --dashboard-body '{
        "widgets": [
            {
                "type": "metric",
                "properties": {
                    "metrics": [
                        ["AWS/Lambda", "Errors", "FunctionName", "'$FUNCTION_NAME'"],
                        ["AWS/Lambda", "Duration", "FunctionName", "'$FUNCTION_NAME'"],
                        ["AWS/Lambda", "Invocations", "FunctionName", "'$FUNCTION_NAME'"]
                    ],
                    "period": 300,
                    "region": "'$REGION'",
                    "title": "Lambda Function Metrics"
                }
            },
            {
                "type": "metric",
                "properties": {
                    "metrics": [
                        ["AWS/SecretsManager", "RotationFailureCount"]
                    ],
                    "period": 300,
                    "region": "'$REGION'",
                    "title": "Secret Rotation Metrics"
                }
            }
        ]
    }'

aws cloudwatch put-dashboard \
    --dashboard-name "MacroMealPlannerDeployment" \
    --dashboard-body file://../aws/monitoring/cloudwatch-config.json

echo "Creating notification rule..."
aws codestar-notifications create-notification-rule \
    --name "secret-rotation-notifications" \
    --detail-type FULL \
    --resource "arn:aws:lambda:$REGION:$(aws sts get-caller-identity --query Account --output text):function:$FUNCTION_NAME" \
    --event-type-ids lambda-function-failed \
    --targets TargetType=SNS,TargetAddress=$SNS_TOPIC_ARN

echo "Monitoring setup complete!"
