# Macro Meal Planner Tech Stack

## Application Architecture

### Frontend
- **Next.js 14**: Full-stack React framework
  - App Router for routing
  - Server Components for performance
  - API Routes for backend functionality
  - Static Site Generation (SSG)
  - Server-Side Rendering (SSR)
  - Styling: Tailwind CSS
  - State Management: React Query

### Backend
- **Node.js**: Runtime environment
- **TypeScript**: Programming language
- **tRPC**: Type-safe API layer
  - End-to-end type safety
  - Automatic API documentation
  - Request validation
  - Error handling

### Database
- **PostgreSQL 15.10**: Primary database
  - Instance Identifier: macro-meal-planner-db
  - Instance Class: db.t3.micro
  - Storage: 20GB GP2
  - Endpoint: macro-meal-planner-db.c9aogqy0mcah.us-east-1.rds.amazonaws.com:5432
  - Backup Window: 03:46-04:16 UTC
  - Maintenance Window: Sunday 06:18-06:48 UTC
  - JSONB for flexible data storage
  - Full-text search capabilities
  - Complex query support
  - Connection pooling
- **Prisma**: ORM and database toolkit
  - Schema management
  - Migrations
  - Type-safe queries
  - Connection pooling

### Authentication & Security
- **NextAuth.js**: Authentication framework
  - OAuth providers
  - JWT sessions
  - Role-based access
  - Session management
- **AWS Secrets Manager**: Secret management
  - Credential storage
  - Secret rotation
  - Access control
  - Audit logging

## Cloud Infrastructure

### Environment Configuration
- **Local Development** (`.env.local`)
  - Development and testing environment
  - Local PostgreSQL database
  - Local Redis instance
  - Localhost URLs (http://localhost:3000)
  - Debug logging enabled
  - CDN disabled

- **Staging** (`.env.staging`)
  - Pre-production environment on AWS
  - AWS Amplify URL: https://develop.dole2coul5w42.amplifyapp.com
  - Staging PostgreSQL RDS instance
  - Info level logging
  - CDN enabled
  - Full AWS service integration

- **Production** (`.env.production`)
  - Production environment on AWS
  - AWS Amplify URL: https://main.dole2coul5w42.amplifyapp.com
  - Production PostgreSQL RDS instance
  - Warning level logging
  - CDN enabled
  - Full AWS service integration

### AWS Services
- **AWS Amplify**: Application hosting
  - App ID: dole2coul5w42
  - Default Domain: dole2coul5w42.amplifyapp.com
  - Production Branch: https://main.dole2coul5w42.amplifyapp.com
  - Development Branch: https://develop.dole2coul5w42.amplifyapp.com
  - Auto Build: Enabled for all branches
  - Framework: Next.js - SSR
  - Performance Mode: Available (not enabled)
  - IAM Roles:
    - Staging: macro-meal-planner-staging-amplify-role
    - Production: macro-meal-planner-prod-amplify-role
    - Permissions: S3 access, Secrets Manager access

- **AWS RDS**: Database hosting
  - Production Instance:
    - Identifier: macro-meal-planner-prod
    - Engine: PostgreSQL 15.10
    - Instance Class: db.t3.micro
    - Storage: 20GB GP2
    - Endpoint: macro-meal-planner-prod.c9aogqy0mcah.us-east-1.rds.amazonaws.com
    - Automated backups (7-day retention)
    - Point-in-time recovery
  - Staging Instance:
    - Identifier: macro-meal-planner-staging
    - Engine: PostgreSQL 15.10
    - Instance Class: db.t3.micro
    - Storage: 20GB GP2
    - Endpoint: macro-meal-planner-staging.c9aogqy0mcah.us-east-1.rds.amazonaws.com
    - Automated backups (1-day retention)
  - Features:
    - Performance monitoring
    - High availability options
    - Encryption at rest

- **AWS S3**: Storage service
  - Production Bucket: macro-meal-planner-prod
    - Private access only
    - CORS enabled
    - Lifecycle rules configured
    - Bucket policy with Amplify role access
  - Staging Bucket: macro-meal-planner-staging
    - Private access only
    - CORS enabled
    - Lifecycle rules configured
    - Bucket policy with Amplify role access
  - Use Cases:
    - Build artifacts
    - Static assets
    - User uploads

- **AWS Secrets Manager**: Secret management
  - Production Secret Group: macro-meal-planner/production
    - Database credentials
    - NextAuth secret
    - GitHub OAuth credentials
    - OpenAI API key
  - Staging Secret Group: macro-meal-planner/staging
    - Database credentials
    - NextAuth secret
    - GitHub OAuth credentials
    - OpenAI API key
  - Features:
    - Automatic secret rotation (30-day schedule)
    - Lambda rotation function
    - IAM-based access control
    - Audit logging

- **AWS Lambda**: Serverless functions
  - Secret Rotation Function:
    - Name: macro-meal-planner-secret-rotation
    - Runtime: Python 3.9
    - Memory: 128MB
    - Timeout: 30 seconds
    - IAM Role: macro-meal-planner-rotation-role
    - Permissions: Secrets Manager access, CloudWatch Logs

- **AWS CloudWatch**: Monitoring
  - Application metrics
  - Database monitoring
  - Lambda function logs
  - Custom dashboards
  - Alert management
  - Configured alarms:
    - RDS CPU utilization
    - RDS storage space
    - RDS connection count

### CI/CD Pipeline
- **GitHub Actions**: Automation platform
  - Automated testing
  - Build verification
  - Deployment pipeline
  - Preview environments
  - Environment management

### Security
- **AWS Security Groups**:
  - RDS Group (sg-068f4e5d4053c1b8f):
    - PostgreSQL (5432): 0.0.0.0/0 (Development)
    - VPC: vpc-018c9716151f6a684
- **AWS IAM**: Access management
  - Admin User: macro-meal-planner-admin
  - Policies:
    - AWSAmplifyServiceRole
    - AmazonRDSFullAccess
    - AmazonS3FullAccess
    - CloudWatchFullAccess
    - SecretsManagerReadWrite
- **SSL/TLS**: Data encryption
  - In-transit encryption
  - Certificate management
  - Secure endpoints

## Development Tools

### Code Quality
- **ESLint**: Code linting
- **Prettier**: Code formatting
- **TypeScript**: Type safety
- **Husky**: Git hooks
- **Commitlint**: Commit messages

### Testing
- **Jest**: Unit testing
- **Cypress**: E2E testing
- **Prisma Testing**: Database testing
- **GitHub Actions**: CI testing

### Development Experience
- **VS Code**: Primary IDE
- **Docker**: Containerization
- **npm**: Package management
- **AWS CLI**: Infrastructure management

### Documentation
- **Markdown**: Documentation format
- **OpenAPI/Swagger**: API documentation
- **Storybook**: Component documentation
- **GitHub Wiki**: Project documentation

## Environment Configuration
Required environment variables:
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_AMPLIFY_APP_ID
AWS_REGION
TEST_DATABASE_URL
PRODUCTION_DATABASE_URL
NEXTAUTH_SECRET
PRODUCTION_NEXTAUTH_URL
AUTH_GITHUB_ID
AUTH_GITHUB_SECRET
OPENAI_API_KEY
```

## Monitoring & Observability
- **AWS CloudWatch**
  - Application metrics
  - Database monitoring
  - Custom dashboards
  - Alert management
  - Configured alarms:
    - RDS CPU utilization
    - RDS storage space
    - RDS connection count
- **AWS X-Ray**
  - Distributed tracing
  - Performance analysis
  - Service maps
  - Error tracking
