#!/bin/bash

# Variables
STAGING_BUCKET="macro-meal-planner-staging"
PROD_BUCKET="macro-meal-planner-prod"
REGION="us-east-1"

# CORS configuration
CORS_CONFIG='{
    "CORSRules": [
        {
            "AllowedHeaders": ["*"],
            "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
            "AllowedOrigins": ["*"],
            "ExposeHeaders": ["ETag"]
        }
    ]
}'

# Create staging bucket
echo "Creating staging bucket..."
aws s3api create-bucket \
    --bucket $STAGING_BUCKET \
    --region $REGION

# Add staging tags
aws s3api put-bucket-tagging \
    --bucket $STAGING_BUCKET \
    --tagging 'TagSet=[{Key=Environment,Value=staging},{Key=Project,Value=macro-meal-planner}]'

# Configure staging CORS
aws s3api put-bucket-cors \
    --bucket $STAGING_BUCKET \
    --cors-configuration "$CORS_CONFIG"

# Create production bucket
echo "Creating production bucket..."
aws s3api create-bucket \
    --bucket $PROD_BUCKET \
    --region $REGION

# Add production tags
aws s3api put-bucket-tagging \
    --bucket $PROD_BUCKET \
    --tagging 'TagSet=[{Key=Environment,Value=production},{Key=Project,Value=macro-meal-planner}]'

# Configure production CORS
aws s3api put-bucket-cors \
    --bucket $PROD_BUCKET \
    --cors-configuration "$CORS_CONFIG"

# Configure lifecycle rules for both buckets (optional)
LIFECYCLE_CONFIG='{
    "Rules": [
        {
            "ID": "DeleteOldFiles",
            "Status": "Enabled",
            "Expiration": {
                "Days": 30
            }
        }
    ]
}'

aws s3api put-bucket-lifecycle-configuration \
    --bucket $STAGING_BUCKET \
    --lifecycle-configuration "$LIFECYCLE_CONFIG"

aws s3api put-bucket-lifecycle-configuration \
    --bucket $PROD_BUCKET \
    --lifecycle-configuration "$LIFECYCLE_CONFIG"

echo "S3 buckets created and configured successfully!"
echo "Staging bucket: $STAGING_BUCKET"
echo "Production bucket: $PROD_BUCKET"
