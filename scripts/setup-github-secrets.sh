#!/bin/bash

# This script helps set up GitHub secrets for the repository
# You'll need the GitHub CLI (gh) installed and authenticated

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Setting up GitHub secrets for CI/CD..."

# Function to set a secret if not empty
set_secret() {
    local secret_name=$1
    local secret_value=$2
    
    if [ -n "$secret_value" ]; then
        echo -n "$secret_value" | gh secret set "$secret_name"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓${NC} Set $secret_name"
        else
            echo -e "${RED}✗${NC} Failed to set $secret_name"
        fi
    else
        echo -e "${RED}✗${NC} Empty value for $secret_name"
    fi
}

# Read values from staging environment file
if [ -f ".env.staging" ]; then
    source .env.staging
    set_secret "STAGING_DATABASE_URL" "$DATABASE_URL"
    set_secret "STAGING_NEXTAUTH_URL" "https://develop.dole2coul5w42.amplifyapp.com"
else
    echo -e "${RED}✗${NC} .env.staging file not found"
fi

# Read values from production environment file
if [ -f ".env.production" ]; then
    source .env.production
    set_secret "NEXTAUTH_SECRET" "$NEXTAUTH_SECRET"
    set_secret "AUTH_GITHUB_ID" "$AUTH_GITHUB_ID"
    set_secret "AUTH_GITHUB_SECRET" "$AUTH_GITHUB_SECRET"
    set_secret "OPENAI_API_KEY" "$OPENAI_API_KEY"
else
    echo -e "${RED}✗${NC} .env.production file not found"
fi

echo -e "\nDone setting up secrets!"
echo "Please verify all secrets are set correctly in your GitHub repository settings:"
echo "https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/settings/secrets/actions"
