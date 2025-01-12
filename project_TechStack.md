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
- **PostgreSQL RDS**: Primary database
  - Instance Class: db.t4g.small (ARM-based for cost efficiency)
  - Storage: GP3 for better performance
  - Automated backups with 7-day retention
  - Enhanced monitoring enabled
  - Performance Insights enabled
  - Features utilized:
    - JSONB for flexible data storage
    - Full-text search with tsvector
    - Array types for tags and categories
    - Check constraints for data integrity
    - Proper indexing strategy
- **Prisma**: ORM and database toolkit
  - Schema management
  - Migrations
  - Type-safe queries
  - Connection pooling

### Authentication & Security
- **NextAuth.js**: Authentication framework
  - OAuth providers (GitHub)
  - JWT sessions
  - Role-based access
  - Session management
- **AWS Secrets Manager**: Secret management
  - Credential storage
  - Secret rotation
  - Access control
  - Audit logging

## Deployment Architecture

### AWS Amplify
**Decision**: Use AWS Amplify as our primary deployment and hosting platform
**Rationale**:
- Simplified deployment pipeline with built-in CI/CD
- Native integration with other AWS services
- Automatic SSL/TLS certificate management
- Built-in preview environments for pull requests
- Zero-config server-side rendering support for Next.js

### Infrastructure Components

#### Frontend Hosting
- **Service**: AWS Amplify Hosting
- **Framework**: Next.js 14
- **Build System**: Node.js 18
- **Static Assets**: Served via Amplify's CDN

#### Database
- **Service**: AWS RDS (PostgreSQL)
- **Access**: IAM Authentication
- **Connection**: SSL/TLS encrypted

#### Environment Management
- **Development**: Local environment with Docker
- **Staging**: Amplify branch deployment (develop)
- **Production**: Amplify branch deployment (main)

### Build and Deploy Process
1. Code pushed to GitHub repository
2. Amplify automatically detects changes
3. Builds application using `amplify.yml`
4. Runs environment validation
5. Deploys to appropriate environment

### Security
- SSL/TLS encryption for all environments
- IAM role-based access control
- Secrets managed via AWS Parameter Store
- Database access restricted to VPC

### Monitoring
- AWS CloudWatch for logs and metrics
- Amplify built-in monitoring
- Custom health check endpoints

## Alternatives Considered

### GitHub Actions + AWS Elastic Beanstalk
**Rejected because**:
- More complex configuration required
- Additional maintenance overhead
- Manual SSL certificate management

### Vercel
**Rejected because**:
- Less integration with AWS services
- Higher costs at scale
- Limited database options

## Migration Plan
1. Set up new Amplify app
2. Configure build settings
3. Set up environment variables
4. Migrate database
5. Update DNS records
6. Validate deployment

## AWS Infrastructure

### Compute & Hosting
- **AWS Amplify**: Application hosting
  - App ID: dnmfawxs8f2l8
  - Default Domain: dnmfawxs8f2l8.amplifyapp.com
  - Production Branch: main
  - Development Branch: develop
  - Framework: Next.js - SSR
  - Build settings:
    - Node version: 18
    - Build command: npm run build
    - Start command: npm start
  - Environment variables managed via Amplify Console

### Database
- **AWS RDS**: PostgreSQL hosting
  - Production Instance:
    - Identifier: macro-meal-planner-prod
    - Engine: PostgreSQL 15.10
    - Instance Class: db.t4g.small
    - Storage: 20GB GP3
    - Automated backups (7-day retention)
  - Staging Instance:
    - Identifier: macro-meal-planner-staging
    - Engine: PostgreSQL 15.10
    - Instance Class: db.t4g.small
    - Storage: 20GB GP3
    - Automated backups (1-day retention)

### Storage
- **AWS S3**: Object storage
  - Production Bucket: macro-meal-planner-prod
    - Private access
    - CORS enabled
    - Lifecycle rules
  - Staging Bucket: macro-meal-planner-staging
    - Private access
    - CORS enabled
    - Lifecycle rules

### Security & Configuration
- **AWS Secrets Manager**:
  - Production secrets: macro-meal-planner/production
  - Staging secrets: macro-meal-planner/staging
  - Automatic rotation (30 days)
  - IAM-based access

- **AWS IAM**: Access management
  - Admin User: macro-meal-planner-admin
  - Service Roles:
    - Amplify roles (staging/prod)
    - RDS roles
    - S3 roles
    - Secrets Manager roles

### Monitoring
- **AWS CloudWatch**:
  - Application logs
  - RDS monitoring
  - Custom metrics
  - Alarms:
    - RDS CPU/Storage
    - Application errors
    - API latency

### CI/CD Pipeline
- **AWS CodePipeline**: Primary CI/CD tool
  - Source: AWS CodeCommit
  - Build: AWS CodeBuild
  - Deploy: ECS deployment
  
- **Database Migrations**:
  - Pre-migration snapshots
  - Checksum validation
  - Transaction wrapping
  - Migration history tracking
  - Automated rollback procedures
  - Slack notifications
  - CloudWatch monitoring

### Deployment Environments
- **Staging**:
  - RDS: db.t4g.small
  - ECS: Fargate spot
  - 7-day backup retention
  - Full monitoring suite
  
- **Production** (Planned):
  - RDS: db.t4g.medium
  - ECS: Fargate dedicated
  - 30-day backup retention
  - Enhanced monitoring
  - Read replicas (future)

## Development Tools
- **VS Code**: Primary IDE
- **ESLint & Prettier**: Code quality
- **TypeScript**: Type safety
- **Jest & Cypress**: Testing
- **AWS CLI**: Infrastructure management

## Environment Variables
Required variables:
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_AMPLIFY_APP_ID
DATABASE_URL
NEXTAUTH_SECRET
NEXTAUTH_URL
GITHUB_ID
GITHUB_SECRET
```

## Recent Technical Changes (January 11, 2025)

### AWS Amplify Configuration
- Added build environment detection in health check
- Implemented optional parameter support with defaults
- Enhanced SSM parameter loading with error handling
- Configured NODE_ENV=build during build process
- Updated IAM policy `AmplifySSMAccess` for parameter access

### Environment Configuration
- Required Parameters:
  - NEXTAUTH_URL
  - DATABASE_URL
  - AUTH_GITHUB_ID
  - AUTH_GITHUB_SECRET
  - NEXTAUTH_SECRET
  - OPENAI_API_KEY
- Optional Parameters (with defaults):
  - NODE_ENV=build
  - PORT=3000
  - APP_URL=https://{branch}.{appId}.amplifyapp.com
  - AWS_S3_BUCKET=macro-meal-planner-{env}
  - AWS_REGION=us-east-1
  - DATABASE_SSL_ENABLED=true
  - DATABASE_CONNECTION_LIMIT=5

### Deployment Status
- Application ID: dnmfawxs8f2l8
- Staging URL: https://develop.dnmfawxs8f2l8.amplifyapp.com
- Production URL: https://main.dnmfawxs8f2l8.amplifyapp.com

## Deployment Learnings (2025-01-11)

#### Build Process
- **Build Artifacts**: 
  - `.next` directory must be excluded from git
  - Build artifacts are generated during Amplify deployment
  - Separate build process for staging and production

#### Environment Configuration
- **Parameter Store Structure**:
  ```
  /macro-meal-planner/
    ├── staging/
    │   ├── APP_ENV
    │   ├── DATABASE_URL
    │   ├── NEXTAUTH_URL
    │   └── ...
    └── production/
        ├── APP_ENV
        ├── DATABASE_URL
        ├── NEXTAUTH_URL
        └── ...
  ```
- **Secret Management**:
  - All parameters stored as SecureString type
  - Automatic parameter loading via `amplify.yml`
  - Environment-specific parameter paths

#### Deployment Strategy
- **Direct Repository Connection**:
  - GitHub integration required for automated builds
  - Manual deployments possible but not recommended
  - Branch-based environment mapping

#### Infrastructure Considerations
- **Build Configuration**:
  - Node.js 18 runtime
  - Environment validation through custom scripts
  - Build artifact caching in `.next/cache`
- **Security**:
  - IAM roles for SSM parameter access
  - Secure environment variable handling
  - Branch protection rules needed

## Current Deployment Status (2025-01-11)

#### AWS Amplify Configuration
- **App ID**: dnmfawxs8f2l8
- **Default Domain**: dnmfawxs8f2l8.amplifyapp.com
- **Branches**:
  - Production (main): Configured, pending initial deployment
  - Staging (develop): Configured, pending initial deployment
- **Framework**: Next.js - SSR
- **Environment Management**: AWS Parameter Store
- **Build Configuration**: 
  - Node.js 18
  - Automated builds on push
  - Environment validation
  - Health checks implemented

#### Environment Variables
- **Storage**: AWS Parameter Store
- **Path Structure**:
  - Production: /macro-meal-planner/production/*
  - Staging: /macro-meal-planner/staging/*
- **Security**: SecureString parameter type
- **Sync Status**: Configured and synced

#### Deployment Pipeline
- **Source Control**: GitHub
- **Build Trigger**: Automatic on push
- **Environments**:
  - Staging: develop branch
  - Production: main branch
- **Status**: Infrastructure ready, awaiting initial deployment

## Infrastructure as Code

### Terraform Modules
- **VPC Module**
  - Public and private subnets across multiple AZs
  - NAT Gateways for private subnet access
  - Internet Gateway for public access
  - Security group management
  - Route table configurations

- **Database Module**
  - Aurora Serverless v2 PostgreSQL cluster
  - Subnet groups and parameter groups
  - Automated backup configurations
  - Monitoring and alerting setup

- **Application Module**
  - ECS Fargate cluster
  - Application Load Balancer
  - Auto-scaling configurations
  - Task definitions and service setups

### State Management
- **Backend State**
  - S3 bucket for state storage
  - DynamoDB for state locking
  - Workspace management
  - State versioning
