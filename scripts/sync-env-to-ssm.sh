#!/bin/bash

# Function to sync environment variables to SSM Parameter Store
sync_env_to_ssm() {
    local env=$1
    local env_file=".env.${env}"
    
    echo "Syncing ${env} environment variables to SSM Parameter Store..."
    
    # Read each line from the environment file
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ $line =~ ^#.*$ ]] && continue
        [[ -z $line ]] && continue
        
        # Extract key and value
        key=$(echo "$line" | cut -d'=' -f1)
        value=$(echo "$line" | cut -d'=' -f2-)
        
        # Remove any quotes from the value
        value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
        
        # Create or update parameter in SSM
        aws ssm put-parameter \
            --name "/macro-meal-planner/${env}/${key}" \
            --value "${value}" \
            --type "SecureString" \
            --overwrite \
            --region "us-east-1"
            
        echo "Updated parameter: ${key}"
    done < "$env_file"
    
    echo "Completed syncing ${env} environment variables"
}

# Make the script executable
chmod +x sync-env-to-ssm.sh

# Sync staging environment
sync_env_to_ssm "staging"

# Sync production environment
sync_env_to_ssm "production"
