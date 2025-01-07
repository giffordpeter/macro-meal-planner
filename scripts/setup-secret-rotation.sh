#!/bin/bash

# Exit on error
set -e

# Variables
REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
LAMBDA_ROLE_NAME="macro-meal-planner-secret-rotation-role"
SNS_TOPIC_NAME="secret-rotation-alerts"
LAMBDA_FUNCTION_NAME="macro-meal-planner-secret-rotation"

echo "Setting up secret rotation..."

# Create SNS topic for monitoring
echo "Creating SNS topic..."
SNS_TOPIC_ARN=$(aws sns create-topic \
    --name "$SNS_TOPIC_NAME" \
    --region "$REGION" \
    --output text \
    --query 'TopicArn')

# Create IAM role for Lambda
echo "Creating IAM role for Lambda..."
aws iam create-role \
    --role-name "$LAMBDA_ROLE_NAME" \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }]
    }'

# Attach policies to the role
echo "Attaching policies to IAM role..."
aws iam attach-role-policy \
    --role-name "$LAMBDA_ROLE_NAME" \
    --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

aws iam put-role-policy \
    --role-name "$LAMBDA_ROLE_NAME" \
    --policy-name "SecretRotationPolicy" \
    --policy-document '{
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:PutSecretValue",
                "secretsmanager:UpdateSecret",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": "*"
        }, {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "'$SNS_TOPIC_ARN'"
        }]
    }'

# Create CloudWatch log group
echo "Creating CloudWatch log group..."
aws logs create-log-group \
    --log-group-name "/aws/lambda/$LAMBDA_FUNCTION_NAME"

# Update rotation config with account ID
echo "Updating rotation config..."
sed -i '' "s/ACCOUNT_ID/$ACCOUNT_ID/g" aws/lambda/secret-rotation/rotation-config.json

# Create Lambda function
echo "Creating Lambda function..."
cd aws/lambda/secret-rotation
zip -r function.zip index.py
aws lambda create-function \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --runtime "python3.9" \
    --role "arn:aws:iam::$ACCOUNT_ID:role/$LAMBDA_ROLE_NAME" \
    --handler "index.lambda_handler" \
    --zip-file "fileb://function.zip" \
    --environment "Variables={SNS_TOPIC_ARN=$SNS_TOPIC_ARN}" \
    --timeout 30 \
    --memory-size 128

# Enable rotation for secrets
echo "Enabling rotation for secrets..."
for SECRET_ID in $(aws secretsmanager list-secrets --query 'SecretList[?Tags[?Key==`Environment`]].ARN' --output text); do
    aws secretsmanager rotate-secret \
        --secret-id "$SECRET_ID" \
        --rotation-lambda-arn "arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$LAMBDA_FUNCTION_NAME" \
        --rotation-rules "AutomaticallyAfterDays=30"
done

echo "Secret rotation setup completed successfully!"
