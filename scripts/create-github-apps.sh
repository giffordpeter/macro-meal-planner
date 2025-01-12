#!/bin/bash

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first:"
    echo "brew install gh"
    exit 1
fi

# Check if logged in
if ! gh auth status &> /dev/null; then
    echo "Please login to GitHub first:"
    echo "gh auth login"
    exit 1
fi

# Function to create OAuth App
create_oauth_app() {
    local env=$1
    local domain="$2.dole2coul5w42.amplifyapp.com"
    local name="Macro Meal Planner"
    
    if [ "$env" = "staging" ]; then
        name="$name (Staging)"
    fi
    
    echo "Creating GitHub OAuth App for $env environment..."
    echo "Name: $name"
    echo "Homepage URL: https://$domain"
    echo "Callback URL: https://$domain/api/auth/callback/github"
    
    # Create the OAuth App using GitHub API
    response=$(gh api \
        --method POST \
        -H "Accept: application/vnd.github.v3+json" \
        /user/oauth-apps \
        -f name="$name" \
        -f url="https://$domain" \
        -f callback_url="https://$domain/api/auth/callback/github" \
        -f description="OAuth app for $name")
    
    # Extract client ID and secret
    client_id=$(echo "$response" | jq -r '.client_id')
    client_secret=$(echo "$response" | jq -r '.client_secret')
    
    echo
    echo "OAuth App created successfully!"
    echo "Environment: $env"
    echo "Client ID: $client_id"
    echo "Client Secret: $client_secret"
    echo
    
    # Save to temporary file
    echo "AUTH_GITHUB_ID=$client_id" >> ".env.$env.oauth"
    echo "AUTH_GITHUB_SECRET=$client_secret" >> ".env.$env.oauth"
}

# Create OAuth Apps for both environments
create_oauth_app "staging" "develop"
create_oauth_app "production" "main"

echo "OAuth apps created successfully!"
echo "Credentials have been saved to .env.staging.oauth and .env.production.oauth"
echo "These files will be used by the environment setup script."
