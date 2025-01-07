#!/bin/bash

# Variables
REGION="us-east-1"
APP_NAME="macro-meal-planner"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create trust policy for Amplify
cat > amplify-trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "amplify.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create staging role
echo "Creating staging Amplify role..."
aws iam create-role \
    --role-name "${APP_NAME}-staging-amplify-role" \
    --assume-role-policy-document file://amplify-trust-policy.json \
    --tags Key=Environment,Value=staging Key=Project,Value=${APP_NAME}

# Create production role
echo "Creating production Amplify role..."
aws iam create-role \
    --role-name "${APP_NAME}-prod-amplify-role" \
    --assume-role-policy-document file://amplify-trust-policy.json \
    --tags Key=Environment,Value=production Key=Project,Value=${APP_NAME}

# Create policy for S3 access
cat > s3-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${APP_NAME}-staging/*",
                "arn:aws:s3:::${APP_NAME}-staging",
                "arn:aws:s3:::${APP_NAME}-prod/*",
                "arn:aws:s3:::${APP_NAME}-prod"
            ]
        }
    ]
}
EOF

# Create policy for Secrets Manager access
cat > secrets-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": [
                "arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:${APP_NAME}/*"
            ]
        }
    ]
}
EOF

# Create and attach policies
echo "Creating and attaching policies..."

# Create policies
aws iam create-policy \
    --policy-name "${APP_NAME}-s3-access" \
    --policy-document file://s3-policy.json

aws iam create-policy \
    --policy-name "${APP_NAME}-secrets-access" \
    --policy-document file://secrets-policy.json

# Attach policies to roles
aws iam attach-role-policy \
    --role-name "${APP_NAME}-staging-amplify-role" \
    --policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/${APP_NAME}-s3-access"

aws iam attach-role-policy \
    --role-name "${APP_NAME}-staging-amplify-role" \
    --policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/${APP_NAME}-secrets-access"

aws iam attach-role-policy \
    --role-name "${APP_NAME}-prod-amplify-role" \
    --policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/${APP_NAME}-s3-access"

aws iam attach-role-policy \
    --role-name "${APP_NAME}-prod-amplify-role" \
    --policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/${APP_NAME}-secrets-access"

# Clean up temporary files
rm amplify-trust-policy.json s3-policy.json secrets-policy.json

echo "IAM setup completed!"
echo "Created roles:"
echo "- ${APP_NAME}-staging-amplify-role"
echo "- ${APP_NAME}-prod-amplify-role"
echo "Created policies:"
echo "- ${APP_NAME}-s3-access"
echo "- ${APP_NAME}-secrets-access"
