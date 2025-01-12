#!/bin/bash

# Create S3 bucket
awslocal s3 mb s3://macro-meal-planner-uploads-local

# Create SNS topic
awslocal sns create-topic --name macro-meal-planner-notifications-local

# Create Secrets Manager secrets
awslocal secretsmanager create-secret \
    --name /macro-meal-planner/local/database \
    --secret-string '{"username":"macro_user","password":"macro_password","host":"db","port":5432,"dbname":"macro_meal_planner"}'

awslocal secretsmanager create-secret \
    --name /macro-meal-planner/local/jwt \
    --secret-string '{"secret":"development_secret","expiration":"24h"}'

# Set bucket policy
awslocal s3api put-bucket-policy \
    --bucket macro-meal-planner-uploads-local \
    --policy '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowLocalAccess",
                "Effect": "Allow",
                "Principal": "*",
                "Action": ["s3:GetObject", "s3:PutObject"],
                "Resource": "arn:aws:s3:::macro-meal-planner-uploads-local/*"
            }
        ]
    }'
