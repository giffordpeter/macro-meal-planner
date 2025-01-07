#!/bin/bash

# Exit on error
set -e

# Set variables
MAIN_DOMAIN="main.dole2coul5w42.amplifyapp.com"
STAGING_DOMAIN="develop.dole2coul5w42.amplifyapp.com"
REGION="us-east-1"

echo "Checking certificate validation status..."

# Get main domain certificate ARN
MAIN_CERT_ARN=$(aws acm list-certificates \
    --region "$REGION" \
    --query "CertificateSummaryList[?DomainName=='$MAIN_DOMAIN'].CertificateArn" \
    --output text)

# Get staging domain certificate ARN
STAGING_CERT_ARN=$(aws acm list-certificates \
    --region "$REGION" \
    --query "CertificateSummaryList[?DomainName=='$STAGING_DOMAIN'].CertificateArn" \
    --output text)

# Check main domain certificate status
echo "Main domain certificate status:"
aws acm describe-certificate \
    --certificate-arn "$MAIN_CERT_ARN" \
    --region "$REGION" \
    --query 'Certificate.Status'

# Check staging domain certificate status
echo "Staging domain certificate status:"
aws acm describe-certificate \
    --certificate-arn "$STAGING_CERT_ARN" \
    --region "$REGION" \
    --query 'Certificate.Status'

# Associate certificates with Amplify app if validated
if [ "$(aws acm describe-certificate --certificate-arn "$MAIN_CERT_ARN" --region "$REGION" --query 'Certificate.Status' --output text)" == "ISSUED" ]; then
    echo "Associating main domain certificate with Amplify app..."
    aws amplify update-domain-association \
        --app-id dole2coul5w42 \
        --domain-name "$MAIN_DOMAIN" \
        --certificate-arn "$MAIN_CERT_ARN"
fi

if [ "$(aws acm describe-certificate --certificate-arn "$STAGING_CERT_ARN" --region "$REGION" --query 'Certificate.Status' --output text)" == "ISSUED" ]; then
    echo "Associating staging domain certificate with Amplify app..."
    aws amplify update-domain-association \
        --app-id dole2coul5w42 \
        --domain-name "$STAGING_DOMAIN" \
        --certificate-arn "$STAGING_CERT_ARN"
fi
