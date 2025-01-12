# GitHub Repository Secrets Setup

The following secrets need to be configured in your GitHub repository for the CI/CD pipeline to work correctly.

## Required Secrets

### AWS Configuration
```
AWS_ACCESS_KEY_ID=<your-aws-access-key>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-key>
AWS_AMPLIFY_APP_ID=dnmfawxs8f2l8
AWS_REGION=us-east-1
```

### Database Configuration
```
DATABASE_URL=<your-database-url>
TEST_DATABASE_URL=postgresql://postgres:<test-password>@<test-host>:5432/macro_meal_planner
PRODUCTION_DATABASE_URL=postgresql://postgres:MacroMealPlanner2024!@macro-meal-planner-db.c9aogqy0mcah.us-east-1.rds.amazonaws.com:5432/macro_meal_planner
```

### Authentication
```
NEXTAUTH_SECRET=<generate-with-openssl-rand-base64-32>
NEXTAUTH_URL=https://develop.dnmfawxs8f2l8.amplifyapp.com
PRODUCTION_NEXTAUTH_URL=https://dnmfawxs8f2l8.amplifyapp.com
AUTH_GITHUB_ID=<your-github-oauth-app-id>
AUTH_GITHUB_SECRET=<your-github-oauth-app-secret>
GITHUB_ID=<your-github-app-id>
GITHUB_SECRET=<your-github-app-secret>
```

### API Keys
```
OPENAI_API_KEY=<your-openai-api-key>
```

## Setting Up Secrets

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Add each secret with its corresponding value

## Generating Secret Values

### NEXTAUTH_SECRET
```bash
openssl rand -base64 32
```

### GitHub OAuth App
1. Go to GitHub Settings > Developer settings > OAuth Apps
2. Create a new OAuth app
3. Set the homepage URL to your Amplify app URL
4. Set the callback URL to `<your-amplify-url>/api/auth/callback/github`

## Verifying Configuration

After setting up all secrets:
1. Go to the Actions tab in your repository
2. Run the "AWS Amplify CI/CD" workflow manually
3. Verify that all steps complete successfully

## Security Notes

- Never commit these secrets to version control
- Rotate secrets regularly
- Use different values for each environment
- Follow the principle of least privilege for AWS IAM users
