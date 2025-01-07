# GitHub Repository Secrets Configuration

## Required Secrets

### AWS Credentials
- `AWS_ACCESS_KEY_ID`: AWS IAM user access key for deployment
- `AWS_SECRET_ACCESS_KEY`: AWS IAM user secret key for deployment
- `AWS_AMPLIFY_APP_ID`: ID of your Amplify application (dole2coul5w42)
- `AWS_REGION`: AWS region where resources are deployed (us-east-1)

### Database Configuration
- `TEST_DATABASE_URL`: Connection string for test database
- `PRODUCTION_DATABASE_URL`: Connection string for production RDS database

### Authentication
- `NEXTAUTH_SECRET`: Random string for NextAuth.js JWT encryption
- `PRODUCTION_NEXTAUTH_URL`: Production URL for NextAuth.js
- `AUTH_GITHUB_ID`: GitHub OAuth application client ID
- `AUTH_GITHUB_SECRET`: GitHub OAuth application client secret

### API Keys
- `OPENAI_API_KEY`: OpenAI API key for AI features

## Setting Up Secrets

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Add each secret listed above with its corresponding value

## Security Notes

- Never commit these values to the repository
- Rotate keys periodically
- Use least-privilege IAM roles
- Monitor secret usage in GitHub Actions
