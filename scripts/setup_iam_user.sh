#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first:"
    echo "brew install awscli"
    exit 1
fi

# Variables
USERNAME="macro-meal-planner-admin"
REQUIRED_POLICIES=(
    "arn:aws:iam::aws:policy/service-role/AWSAmplifyServiceRole"
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
)

echo "Creating IAM user for Macro Meal Planner..."

# Create IAM user
aws iam create-user --user-name $USERNAME

# Attach required policies
for policy in "${REQUIRED_POLICIES[@]}"; do
    echo "Attaching policy: $policy"
    aws iam attach-user-policy --user-name $USERNAME --policy-arn $policy
done

# Create access key
echo "Creating access key..."
aws iam create-access-key --user-name $USERNAME

echo "User creation complete!"
echo "Please save the access key details above securely."
echo "You will need these for GitHub Actions and local development."
