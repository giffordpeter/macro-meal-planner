#!/bin/bash

APP_ID="dole2coul5w42"

echo "Creating and configuring Amplify branches..."

# Create main branch
echo "Creating main branch..."
aws amplify create-branch \
    --app-id $APP_ID \
    --branch-name main \
    --framework "Next.js - SSR" \
    --stage PRODUCTION \
    --enable-auto-build

# Create develop branch
echo "Creating develop branch..."
aws amplify create-branch \
    --app-id $APP_ID \
    --branch-name develop \
    --framework "Next.js - SSR" \
    --stage DEVELOPMENT \
    --enable-auto-build

echo "Branch setup complete!"
echo "Main branch: https://main.$APP_ID.amplifyapp.com"
echo "Develop branch: https://develop.$APP_ID.amplifyapp.com"
