#!/bin/bash

# Exit on error
set -e

# Check if GitHub token is provided
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable is required"
    exit 1
fi

# Repository details
REPO_OWNER="petergifford"
REPO_NAME="macro-meal-planner"
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/branches"

# Configure main branch protection
echo "Configuring main branch protection..."
curl -X PUT \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  "$API_URL/main/protection" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["build_and_deploy"]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "dismissal_restrictions": {},
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true,
      "required_approving_review_count": 1
    },
    "restrictions": null,
    "required_linear_history": true,
    "allow_force_pushes": false,
    "allow_deletions": false
  }'

# Configure develop branch protection
echo "Configuring develop branch protection..."
curl -X PUT \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  "$API_URL/develop/protection" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["build_and_deploy"]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "dismissal_restrictions": {},
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": false,
      "required_approving_review_count": 1
    },
    "restrictions": null,
    "required_linear_history": false,
    "allow_force_pushes": true,
    "allow_deletions": false
  }'

echo "Branch protection rules have been configured successfully."
