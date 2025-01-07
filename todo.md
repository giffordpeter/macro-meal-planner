# Macro Meal Planner - Implementation Tasks

## Database Migration [P0]

### AWS RDS Setup
- [x] Initial Setup
  - [x] Create RDS PostgreSQL instance
  - [x] Configure VPC security groups
  - [x] Set up master credentials
  - [x] Store credentials in Secrets Manager

### Database Configuration
- [x] Security
  - [x] Configure security group rules
  - [ ] Configure SSL/TLS certificates
  - [x] Set up IAM roles and policies
  - [ ] Implement credential rotation

- [ ] High Availability
  - [x] Configure automated backups
  - [x] Set up backup retention policies
  - [ ] Plan Multi-AZ deployment
  - [ ] Configure read replicas (if needed)

- [x] Monitoring
  - [ ] Enable Enhanced Monitoring
  - [x] Set up CloudWatch alarms
  - [ ] Configure performance insights
  - [x] Set up log exports

## CI/CD Implementation [P0]

### AWS Amplify
- [x] Initial Setup
  - [x] Create Amplify application
  - [x] Configure build settings
  - [x] Create build specification
  - [x] Set up S3 artifact storage

- [x] Environment Setup
  - [x] Configure production environment (main branch)
  - [x] Set up preview environments (develop branch)
  - [x] Configure default domain
  - [ ] Set up SSL certificates

### GitHub Actions
- [x] Pipeline Setup
  - [x] Create workflow files
  - [x] Configure build process
  - [x] Set up deployment steps
  - [x] Configure artifact handling

- [x] Security & Configuration
  - [x] Set up AWS credentials
  - [x] Configure repository secrets
  - [x] Set up environment variables
  - [x] Configure branch protection

### Phase 6: Enhanced CI/CD Implementation [P0]

#### 1. Staging Workflow Setup
- [x] Create staging.yml workflow
  - [x] Configure staging environment triggers (develop branch)
  - [x] Set up environment variables for staging
  - [x] Add build and test steps
  - [x] Configure staging deployment
  - [x] Add staging-specific secrets
  - [x] Implement staging environment cleanup

#### 2. Branch Protection Implementation
- [x] Configure Branch Protection Rules
  - [x] Main Branch Protection
    - [x] Require pull request reviews
    - [x] Require status checks to pass
    - [x] Require linear history
    - [x] Include administrators
  - [x] Develop Branch Protection
    - [x] Require pull request reviews
    - [x] Require status checks to pass
    - [x] Allow force pushes for CI
  - [x] Document branch strategy

#### 3. SSL Certificate Configuration
- [x] AWS Certificate Manager Setup
  - [x] Request SSL certificate for main domain
  - [x] Request SSL certificate for staging domain
  - [x] Validate domain ownership
  - [x] Configure DNS records
- [ ] Amplify SSL Integration
  - [ ] Associate certificates with domains
  - [ ] Configure SSL settings in Amplify
  - [ ] Test SSL configuration
  - [ ] Document SSL setup

#### 4. Credential Rotation Implementation
- [x] Database Credentials
  - [x] Create rotation Lambda function
    - [x] Implement password generation
    - [x] Add database connection update
    - [x] Configure error handling
  - [x] Set up rotation schedule
    - [x] Configure 30-day rotation
    - [x] Set up monitoring
    - [x] Add rotation logs
- [x] API Keys and Secrets
  - [x] Implement secret versioning
  - [x] Configure automatic rotation
  - [x] Set up notification system
  - [x] Document rotation process

#### 5. Testing and Verification
- [ ] Staging Pipeline Testing
  - [ ] Test PR creation and merge
  - [ ] Verify environment variables
  - [ ] Check deployment process
- [ ] SSL Verification
  - [ ] Validate HTTPS endpoints
  - [ ] Check certificate chain
  - [ ] Test SSL renewal process
- [ ] Credential Rotation Testing
  - [ ] Test manual rotation
  - [ ] Verify automatic rotation
  - [ ] Check application stability

## Azure to AWS Migration [P0]

### Phase 1: Infrastructure Cleanup
- [x] Remove Azure Static Web Apps
  - [x] Delete `.github/workflows/azure-static-web-apps-lemon-coast-0728dd70f.yml`
  - [x] Remove Azure Static Web Apps API tokens from GitHub secrets:
    - [x] Remove `AZURE_STATIC_WEB_APPS_API_TOKEN` (not present)
    - [x] Remove `AZURE_OPENAI_KEY` (not present)
    - [x] Remove `AZURE_OPENAI_ENDPOINT` (not present)
    - [x] Remove `AZURE_STORAGE_CONNECTION_STRING` (not present)
    - [x] Remove `AZURE_KEYVAULT_URL` (not present)
  - [x] Clean up any Azure-related GitHub Actions secrets

### Phase 2: Secrets Migration
- [x] Migrate Key Vault to AWS Secrets Manager
  - [x] Create AWS Secrets Manager implementation
  - [x] Update secret rotation configuration for AWS
  - [x] Remove Azure Key Vault manager implementation
  - [x] Remove `@azure/identity` and `@azure/keyvault-secrets` dependencies
  - [ ] Test all secrets are accessible in development environment

### Phase 3: Service Migration
- [ ] Migrate OpenAI Integration
  - [ ] Document current Azure OpenAI configuration and endpoints
  - [ ] Update OpenAI configuration to use direct API
  - [ ] Update environment schema for OpenAI changes
  - [ ] Test OpenAI functionality with new configuration
  - [ ] Remove Azure OpenAI environment variables

- [ ] Migrate Storage
  - [ ] Document current Azure Storage usage and patterns
  - [ ] Create equivalent AWS S3 buckets
  - [ ] Configure S3 bucket permissions and policies
  - [ ] Update storage connection strings to use AWS S3
  - [ ] Migrate existing data from Azure Storage to S3
  - [ ] Test all storage operations with S3

### Phase 4: Configuration Updates
- [x] Update Environment Files
  - [x] Update environment schema for AWS
  - [x] Create new AWS configuration in config files
  - [x] Update `NEXTAUTH_URL` to use AWS Amplify URL
  - [x] Consolidate environment files:
    - [x] `.env.local` for local development and testing
    - [x] `.env.staging` for AWS staging
    - [x] `.env.production` for AWS production
  - [x] Remove redundant environment files
  - [x] Update environment documentation

- [x] Update Source Code
  - [x] Update `src/lib/config/env.schema.ts`
  - [x] Refactor `src/lib/config/index.ts` for AWS services
  - [x] Update `src/lib/secrets/` implementations
  - [x] Remove Azure-specific code
  - [x] Add AWS service integrations

### Phase 5: Documentation and Verification
- [ ] Update Documentation
  - [ ] Update deployment documentation for AWS
  - [ ] Update environment variable documentation
  - [ ] Update service integration documentation
  - [ ] Remove all Azure-related documentation
  - [ ] Add AWS troubleshooting guide

- [ ] Final Verification
  - [ ] Test all features in development environment
  - [ ] Verify all AWS services are properly configured
  - [ ] Ensure no Azure dependencies remain
  - [ ] Test deployment pipeline with AWS
  - [ ] Verify all environment variables are updated

## AWS Infrastructure Setup [P0]

### Phase 1: Database Setup
- [x] Update Existing RDS Instance
  - [x] Rename existing instance to macro-meal-planner-prod
  - [x] Add production environment tags
  - [ ] Update production connection strings
- [x] Set up RDS for Staging
  - [x] Create staging RDS instance setup script
    - [x] Instance class: db.t3.micro
    - [x] PostgreSQL 15.10
    - [x] Storage: 20GB GP2
    - [x] Enable automated backups (1-day retention)
  - [x] Configure security group script
    - [x] Create VPC security group
    - [x] Allow inbound PostgreSQL (5432)
    - [x] Restrict to application security group
  - [ ] Set up database
    - [ ] Create staging database
    - [ ] Create application user
    - [ ] Run initial migrations
  - [ ] Update connection string in staging environment

### Phase 2: S3 Storage Setup
- [x] Configure S3 Buckets
  - [x] Create bucket creation scripts
  - [x] Create staging bucket
  - [x] Create production bucket
  - [x] Configure IAM roles and policies
    - [x] Create Amplify IAM roles
    - [x] Create bucket policies
    - [x] Apply bucket policies
  - [x] Update S3 bucket names in environment templates

### Phase 3: Secrets Management
- [x] Set up AWS Secrets Manager
  - [x] Create secrets manager setup script
  - [x] Create staging secret group
    - [x] Store database credentials
    - [x] Store API keys
    - [x] Store OAuth secrets
  - [x] Create production secret group
    - [x] Store database credentials
    - [x] Store API keys
    - [x] Store OAuth secrets
  - [x] Configure secret rotation
    - [x] Create Lambda rotation function
    - [x] Set up rotation schedule

### Phase 4: IAM Setup
- [x] Create IAM Roles
  - [x] Amplify Service Role
    - [x] Create staging role
    - [x] Create production role
    - [x] Attach necessary policies
  - [x] Application Roles
    - [x] S3 access policies
    - [x] Secrets Manager access policies
    - [x] Lambda rotation role

### Phase 5: CI/CD Pipeline
- [ ] Update GitHub Actions Workflow
  - [ ] Create staging workflow
    - [ ] Add staging environment
    - [ ] Configure staging secrets
    - [ ] Set up staging deployment
  - [ ] Update production workflow
    - [ ] Add production environment
    - [ ] Configure production secrets
    - [ ] Set up production deployment
  - [ ] Configure branch protection
    - [ ] Require PR for main
    - [ ] Require status checks
    - [ ] Enable auto-deployment
  - [ ] Add deployment notifications
    - [ ] Success notifications
    - [ ] Failure alerts

### Phase 6: Documentation
- [ ] Update AWS Infrastructure Documentation
  - [ ] Document RDS setup
  - [ ] Document S3 configuration
  - [ ] Document Secrets Manager setup
  - [ ] Document CI/CD pipeline
  - [ ] Add troubleshooting guide

## Application Updates [P1]

### Database Integration
- [ ] Prisma Configuration
  - [ ] Update database schema
  - [ ] Configure connection pooling
  - [ ] Set up migrations
  - [ ] Add health checks

- [ ] Environment Setup
  - [ ] Update connection strings
  - [ ] Configure production settings
  - [ ] Set up environment validation
  - [ ] Add error handling

### Authentication
- [ ] NextAuth.js Setup
  - [ ] Configure OAuth providers
  - [ ] Set up JWT handling
  - [ ] Implement session management
  - [ ] Add role-based access

## Security Implementation [P1]

### AWS Security
- [x] IAM Configuration
  - [x] Create service roles
  - [x] Set up user policies
  - [x] Configure cross-service access
  - [x] Implement least privilege

- [x] Network Security
  - [x] Configure VPC settings
  - [x] Set up security groups
  - [ ] Implement network ACLs
  - [ ] Configure SSL/TLS

### Application Security
- [x] Secrets Management
  - [x] Configure Secrets Manager
  - [ ] Implement secret rotation
  - [x] Set up access policies
  - [ ] Add audit logging

## Documentation [P2]
- [x] Infrastructure Documentation
  - [x] Create tech stack document
  - [x] Document AWS services configuration
  - [x] Document security setup
  - [x] Document monitoring setup

- [ ] Development Documentation
  - [ ] Setup instructions
  - [ ] Local development guide
  - [ ] Deployment procedures
  - [ ] Troubleshooting guide

## Next Steps [P0]
1. Configure SSL/TLS for RDS and domain
2. Set up branch protection rules
3. Implement database schema and migrations
4. Configure NextAuth.js for authentication
5. Add development documentation
6. Test all secrets are accessible in development environment
7. Update `NEXTAUTH_URL` to use AWS Amplify URL
8. Remove Azure variables from environment files

### Phase 7: Final Implementation Steps [P0]

#### 1. SSL Certificate Deployment
- [x] Run Certificate Request Script
  - [x] Execute request-certificates.sh
  - [x] Verify certificate requests in ACM console
  - [x] Record certificate ARNs
  - [x] Check DNS validation records
- [ ] Domain Validation
  - [ ] Add DNS validation records
  - [ ] Run validate-certificates.sh
  - [ ] Monitor validation status
  - [ ] Verify HTTPS endpoints
- [ ] Amplify Integration
  - [ ] Associate certificates with domains
  - [ ] Update domain settings
  - [ ] Test HTTPS access
  - [ ] Update documentation

#### 2. Branch Protection Activation
- [ ] GitHub Token Setup
  - [ ] Create GitHub PAT with repo access
  - [ ] Store token securely
  - [ ] Verify token permissions
- [ ] Protection Rules Deployment
  - [ ] Run configure-branch-protection.sh
  - [ ] Verify main branch rules
  - [ ] Verify develop branch rules
  - [ ] Test PR workflow
- [ ] Documentation Update
  - [ ] Update README with branch rules
  - [ ] Document PR process
  - [ ] Add branch protection details

#### 3. Secret Rotation Deployment
- [x] Lambda Function Deployment
  - [x] Package Lambda function
  - [x] Deploy to AWS
  - [x] Configure IAM roles
  - [x] Set up CloudWatch logs
- [x] Rotation Schedule
  - [x] Run setup-secret-rotation.sh
  - [x] Verify SNS topic creation
  - [x] Check rotation configuration
  - [x] Test manual rotation
- [x] Monitoring Setup
  - [x] Configure CloudWatch alarms
  - [x] Set up notification rules
  - [x] Test alert system
  - [x] Document monitoring

#### 4. Staging Workflow Testing
- [x] Environment Preparation
  - [x] Create test feature branch
  - [x] Add test changes
  - [x] Push to repository
- [ ] PR Testing
  - [ ] Create test PR
  - [ ] Verify status checks
  - [ ] Check preview deployment
  - [ ] Test merge process
- [ ] Production Deploy
  - [ ] Merge to main
  - [ ] Verify production deployment
  - [ ] Check SSL certificate
  - [ ] Validate secret rotation

#### 5. Documentation and Cleanup
- [x] Technical Documentation
  - [x] Update deployment guides
  - [x] Document SSL setup
  - [x] Add rotation procedures
  - [x] Include monitoring details
- [ ] Repository Cleanup
  - [ ] Remove old workflows
  - [ ] Archive unused files
  - [ ] Update .gitignore
  - [ ] Clean up branches