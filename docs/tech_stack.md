# Macro Meal Planner Technical Stack

## Frontend
- **Framework**: Next.js (React)
- **Styling**: Tailwind CSS
- **State Management**: React Context API
- **Authentication**: NextAuth.js with GitHub provider

## Backend
- **Runtime**: Node.js
- **Framework**: Next.js API Routes
- **Database**: PostgreSQL
- **ORM**: Prisma
- **API Integration**: OpenAI API for meal suggestions

## Infrastructure (AWS)

### Compute & Hosting
- **Platform**: AWS Amplify
  - Staging Environment: `develop.dole2coul5w42.amplifyapp.com`
  - Production Environment: `main.dole2coul5w42.amplifyapp.com`

### Database
- **Service**: Amazon RDS (PostgreSQL 15.10)
  - Staging: `macro-meal-planner-staging.c9aogqy0mcah.us-east-1.rds.amazonaws.com`
    - Instance Class: db.t3.micro
    - Storage: 20GB GP2
    - Automated Backups: 1-day retention
  - Production: `macro-meal-planner-prod.c9aogqy0mcah.us-east-1.rds.amazonaws.com`
    - Instance Class: db.t3.micro
    - Storage: 20GB GP2
    - Automated Backups: 7-day retention

### Storage
- **Service**: Amazon S3
  - Staging Bucket: `macro-meal-planner-staging`
    - CORS enabled
    - Lifecycle rules configured
    - Private access only
  - Production Bucket: `macro-meal-planner-prod`
    - CORS enabled
    - Lifecycle rules configured
    - Private access only

### Security & Secrets Management
- **Service**: AWS Secrets Manager
  - Staging Secret Group: `macro-meal-planner/staging`
  - Production Secret Group: `macro-meal-planner/production`
  - Automatic Secret Rotation: Every 30 days via Lambda function
  - Secrets Stored:
    - Database credentials
    - NextAuth secret
    - GitHub OAuth credentials
    - OpenAI API key

### IAM & Access Management
- **Amplify Service Roles**:
  - Staging: `macro-meal-planner-staging-amplify-role`
  - Production: `macro-meal-planner-prod-amplify-role`
  - Permissions:
    - S3 access (read/write)
    - Secrets Manager access (read)

- **Lambda Roles**:
  - Secret Rotation: `macro-meal-planner-rotation-role`
  - Permissions:
    - Secrets Manager access (read/write)
    - CloudWatch Logs access

### Monitoring & Logging
- **Services**:
  - CloudWatch Logs
    - Lambda function logs
    - RDS logs
  - AWS X-Ray (planned)
  - CloudWatch Metrics (planned)

## Development & Deployment

### Environment Management
- Local Development: `.env.local`
- Staging Environment: `.env.staging`
- Production Environment: `.env.production`

### Version Control
- Platform: GitHub
- Branch Strategy:
  - `main`: Production deployments
  - `develop`: Staging deployments
  - Feature branches: `feature/*`

### CI/CD (Planned)
- **Service**: GitHub Actions
- **Workflows**:
  - Staging Deployment
    - Automated tests
    - Database migrations
    - Deployment to AWS Amplify
  - Production Deployment
    - Manual approval
    - Database migrations
    - Deployment to AWS Amplify

## Security Features
- SSL/TLS encryption for all environments
- Secure secret rotation
- Private S3 buckets with strict IAM policies
- Database encryption at rest
- Secure environment variable management
- OAuth 2.0 authentication

## Performance Optimizations
- CDN enabled for static assets
- Database connection pooling
- Edge optimized configurations
- Caching strategy (planned)
