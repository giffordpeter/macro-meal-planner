#!/bin/bash

# Variables
STAGING_BUCKET="macro-meal-planner-staging"
PROD_BUCKET="macro-meal-planner-prod"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create staging bucket policy
cat > staging-bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAmplifyAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${ACCOUNT_ID}:role/macro-meal-planner-staging-amplify-role"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${STAGING_BUCKET}/*",
                "arn:aws:s3:::${STAGING_BUCKET}"
            ]
        },
        {
            "Sid": "DenyPublicAccess",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${STAGING_BUCKET}/*",
                "arn:aws:s3:::${STAGING_BUCKET}"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
EOF

# Create production bucket policy
cat > prod-bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAmplifyAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${ACCOUNT_ID}:role/macro-meal-planner-prod-amplify-role"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${PROD_BUCKET}/*",
                "arn:aws:s3:::${PROD_BUCKET}"
            ]
        },
        {
            "Sid": "DenyPublicAccess",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${PROD_BUCKET}/*",
                "arn:aws:s3:::${PROD_BUCKET}"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
EOF

# Apply policies
echo "Applying staging bucket policy..."
aws s3api put-bucket-policy \
    --bucket $STAGING_BUCKET \
    --policy file://staging-bucket-policy.json

echo "Applying production bucket policy..."
aws s3api put-bucket-policy \
    --bucket $PROD_BUCKET \
    --policy file://prod-bucket-policy.json

# Clean up
rm staging-bucket-policy.json prod-bucket-policy.json

echo "S3 bucket policies updated successfully!"
