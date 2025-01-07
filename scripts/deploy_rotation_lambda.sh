#!/bin/bash

# Variables
FUNCTION_NAME="macro-meal-planner-secret-rotation"
ROLE_NAME="macro-meal-planner-rotation-role"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"

# Create IAM role for Lambda
echo "Creating IAM role for Lambda..."
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://trust-policy.json

# Create policy for Lambda to access Secrets Manager
cat > lambda-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetSecretValue",
                "secretsmanager:PutSecretValue",
                "secretsmanager:UpdateSecretVersionStage"
            ],
            "Resource": "arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:macro-meal-planner/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF

aws iam create-policy \
    --policy-name "${FUNCTION_NAME}-policy" \
    --policy-document file://lambda-policy.json

# Attach policy to role
aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/${FUNCTION_NAME}-policy"

# Wait for role to be ready
echo "Waiting for role to be ready..."
sleep 10

# Create zip file for Lambda
echo "Creating Lambda package..."
cd scripts/lambda
zip -r ../../rotation-lambda.zip rotate_secrets.py
cd ../..

# Create Lambda function
echo "Creating Lambda function..."
aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime python3.9 \
    --handler rotate_secrets.lambda_handler \
    --role "arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}" \
    --zip-file fileb://rotation-lambda.zip \
    --timeout 30 \
    --memory-size 128 \
    --tags "Project=macro-meal-planner"

# Add permissions for Secrets Manager to invoke Lambda
aws lambda add-permission \
    --function-name $FUNCTION_NAME \
    --statement-id SecretsManagerAccess \
    --action lambda:InvokeFunction \
    --principal secretsmanager.amazonaws.com

# Clean up
rm trust-policy.json lambda-policy.json rotation-lambda.zip

echo "Lambda function deployment completed!"
echo "Function ARN: arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${FUNCTION_NAME}"
