#!/bin/bash

# Exit on error
set -e

# Set variables
MAIN_DOMAIN="main.dole2coul5w42.amplifyapp.com"
STAGING_DOMAIN="develop.dole2coul5w42.amplifyapp.com"
REGION="us-east-1"

echo "Requesting SSL certificates from AWS Certificate Manager..."

# Request certificate for main domain
MAIN_CERT_ARN=$(aws acm request-certificate \
    --domain-name "$MAIN_DOMAIN" \
    --validation-method DNS \
    --region "$REGION" \
    --output text \
    --query 'CertificateArn')

echo "Main domain certificate requested. ARN: $MAIN_CERT_ARN"

# Request certificate for staging domain
STAGING_CERT_ARN=$(aws acm request-certificate \
    --domain-name "$STAGING_DOMAIN" \
    --validation-method DNS \
    --region "$REGION" \
    --output text \
    --query 'CertificateArn')

echo "Staging domain certificate requested. ARN: $STAGING_CERT_ARN"

# Get DNS validation records for main domain
echo "Getting DNS validation records for main domain..."
aws acm describe-certificate \
    --certificate-arn "$MAIN_CERT_ARN" \
    --region "$REGION" \
    --query 'Certificate.DomainValidationOptions[].ResourceRecord'

# Get DNS validation records for staging domain
echo "Getting DNS validation records for staging domain..."
aws acm describe-certificate \
    --certificate-arn "$STAGING_CERT_ARN" \
    --region "$REGION" \
    --query 'Certificate.DomainValidationOptions[].ResourceRecord'

echo "Please add the above DNS records to validate domain ownership."
echo "After adding DNS records, run validate-certificates.sh to check validation status."
