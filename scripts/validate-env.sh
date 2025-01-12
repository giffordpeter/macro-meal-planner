#!/bin/bash

# Exit on error
set -e

# Required environment variables
REQUIRED_VARS=(
    "NEXTAUTH_URL"
    "DATABASE_URL"
    "AUTH_GITHUB_ID"
    "AUTH_GITHUB_SECRET"
    "NEXTAUTH_SECRET"
    "OPENAI_API_KEY"
    "NODE_ENV"
    "DATABASE_SECRET_NAME"
)

# Optional environment variables with default values
declare PORT_DEFAULT="3000"
declare API_TIMEOUT_DEFAULT="30000"
declare LOG_LEVEL_DEFAULT="info"

echo "Validating environment variables..."

# Check required variables
MISSING_VARS=()
for VAR in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!VAR}" ]]; then
        MISSING_VARS+=("$VAR")
    fi
done

# Set default values for optional variables
if [[ -z "${PORT}" ]]; then
    export PORT="${PORT_DEFAULT}"
    echo "Setting default value for PORT: ${PORT_DEFAULT}"
fi

if [[ -z "${API_TIMEOUT}" ]]; then
    export API_TIMEOUT="${API_TIMEOUT_DEFAULT}"
    echo "Setting default value for API_TIMEOUT: ${API_TIMEOUT_DEFAULT}"
fi

if [[ -z "${LOG_LEVEL}" ]]; then
    export LOG_LEVEL="${LOG_LEVEL_DEFAULT}"
    echo "Setting default value for LOG_LEVEL: ${LOG_LEVEL_DEFAULT}"
fi

# Validate DATABASE_URL format
if [[ ! -z "${DATABASE_URL}" ]] && [[ ! "${DATABASE_URL}" =~ ^postgres(ql)?:\/\/[a-zA-Z0-9_-]+:[^@]+@[^:]+:[0-9]+\/[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: DATABASE_URL format is invalid"
    exit 1
fi

# Validate NEXTAUTH_URL format
if [[ ! -z "${NEXTAUTH_URL}" ]] && [[ ! "${NEXTAUTH_URL}" =~ ^https?:\/\/ ]]; then
    echo "Error: NEXTAUTH_URL must start with http:// or https://"
    exit 1
fi

# Check if any required variables are missing
if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo "Error: Missing required environment variables:"
    printf '%s\n' "${MISSING_VARS[@]}"
    exit 1
fi

# Validate NODE_ENV
if [[ ! -z "${NODE_ENV}" ]] && [[ ! "${NODE_ENV}" =~ ^(development|production|test|staging)$ ]]; then
    echo "Error: NODE_ENV must be one of: development, production, test, staging"
    exit 1
fi

# Test database connection if URL is provided
if [[ ! -z "${DATABASE_URL}" ]]; then
    DB_HOST=$(echo $DATABASE_URL | sed -E 's/.*@([^:]+):.*/\1/')
    DB_PORT=$(echo $DATABASE_URL | sed -E 's/.*:([0-9]+)\/.*/\1/')
    
    if ! nc -z -w5 $DB_HOST $DB_PORT 2>/dev/null; then
        echo "Error: Cannot connect to database at $DB_HOST:$DB_PORT"
        exit 1
    fi
fi

echo "Environment validation successful!"
