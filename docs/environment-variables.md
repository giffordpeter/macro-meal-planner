# Environment Variables Documentation

This document describes all environment variables used in the Macro Meal Planner application.

## Production Environment Variables

### Database Configuration
- `DATABASE_URL`: PostgreSQL connection string
  - Format: `postgresql://[user]:[password]@[host]:[port]/[dbname]`
  - Example: `postgresql://postgres:password@hostname:5432/macro_meal_planner`
  - Required: Yes

### AWS Configuration
- `AWS_REGION`: AWS region where resources are deployed
  - Default: `us-east-1`
  - Required: Yes
- `AWS_SECRET_NAME`: Name of the AWS Secrets Manager secret containing database credentials
  - Example: `macro-meal-planner/production/database`
  - Required: Yes

### Security
- `NODE_ENV`: Environment name
  - Values: `production`, `development`, `test`
  - Required: Yes
- `SESSION_SECRET`: Secret key for session management
  - Must be a secure random string
  - Required: Yes

### Application Settings
- `API_URL`: Base URL for API endpoints
  - Format: Full URL including protocol
  - Example: `https://api.yourdomain.com`
  - Required: Yes
- `CORS_ORIGIN`: Allowed origin for CORS
  - Format: Full URL including protocol
  - Example: `https://yourdomain.com`
  - Required: Yes

### Feature Flags
- `ENABLE_CACHING`: Enable/disable caching features
  - Values: `true`, `false`
  - Default: `true`
  - Required: No
- `ENABLE_MONITORING`: Enable/disable monitoring features
  - Values: `true`, `false`
  - Default: `true`
  - Required: No

## Setting Up Environment Variables

1. Copy `.env.production.template` to `.env.production`
2. Fill in all required variables
3. Generate secure values for secrets:
   ```bash
   # Generate SESSION_SECRET
   openssl rand -base64 32
   ```

## AWS Secrets Manager

Database credentials are stored in AWS Secrets Manager. To access them:

1. Ensure AWS CLI is configured
2. Use the following command to retrieve secrets:
   ```bash
   aws secretsmanager get-secret-value --secret-id macro-meal-planner/production/database
   ```

## Security Notes

- Never commit `.env` files to version control
- Rotate secrets regularly
- Use different values for each environment
- Keep production credentials strictly separate from development
