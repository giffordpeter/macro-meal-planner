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
  - OAuth providers (GitHub)
  - JWT sessions
  - Role-based access
  - Session management
- **AWS Secrets Manager**: Secret management
  - Credential storage
  - Secret rotation
  - Access control
  - Audit logging

## AWS Infrastructure

### Compute & Hosting
- **AWS Amplify**: Application hosting
  - App ID: dole2coul5w42
  - Default Domain: dole2coul5w42.amplifyapp.com
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
    - Instance Class: db.t3.micro
    - Storage: 20GB GP2
    - Automated backups (7-day retention)
  - Staging Instance:
    - Identifier: macro-meal-planner-staging
    - Engine: PostgreSQL 15.10
    - Instance Class: db.t3.micro
    - Storage: 20GB GP2
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

### Deployment Pipeline (To Be Redesigned)
- **Current**:
  - GitHub Actions for CI/CD
  - AWS Amplify for hosting
  - Branch-based deployments
- **Planned Improvements**:
  - Simplified deployment process
  - Better error handling
  - Improved rollback capabilities
  - Enhanced monitoring

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
