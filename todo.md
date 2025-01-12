# Macro Meal Planner - Project Todo

## Immediate Tasks (Next 2 Weeks)

### Week 1: Development Environment Setup
1. Local Development Setup
   - [ ] Create docker-compose.yml for local services
   - [ ] Set up development database
   - [ ] Configure local secrets management
   - [ ] Create development documentation

2. API Project Structure
   - [ ] Set up FastAPI project layout
   - [ ] Configure dependency injection
   - [ ] Add logging and monitoring
   - [ ] Set up error handling

3. Frontend Project Structure
   - [ ] Initialize Next.js project
   - [ ] Set up TypeScript configuration
   - [ ] Configure build pipeline
   - [ ] Add basic routing

### Week 2: Core Features Development
1. User Authentication
   - [ ] Implement JWT authentication
   - [ ] Create user registration
   - [ ] Add password reset flow
   - [ ] Set up email verification

2. Database Models
   - [ ] Create user model
   - [ ] Add recipe model
   - [ ] Implement meal plan model
   - [ ] Set up ingredient model

3. Basic UI Components
   - [ ] Create component library
   - [ ] Add authentication forms
   - [ ] Implement navigation
   - [ ] Design dashboard layout

## Current Focus Areas

### 1. Database Development
- [ ] Create initial seed data
  - Sample users with profiles
  - Base recipe collection
  - Common ingredients database
  - Example meal plans
- [ ] Write database testing framework
  - Unit tests for models
  - Integration tests for queries
  - Performance benchmarks
- [ ] Document migration procedures
  - Development workflow
  - Testing process
  - Rollback procedures
  - Emergency recovery steps

### 2. API Development
- [ ] Implement authentication
  - Role-based access control
  - Session management
- [ ] Create user management endpoints
  - Profile management
  - Preference settings
  - Activity tracking
- [ ] Implement meal planning endpoints
  - Recipe CRUD
  - Meal plan generation
  - Shopping list creation
  - Nutrition tracking

### 3. Frontend Development
- [ ] Implement authentication UI
  - Profile management
  - Settings pages
- [ ] Add meal planning interface
  - Recipe browser
  - Meal calendar
  - Shopping list view
  - Nutrition dashboard

## Testing Infrastructure
- [ ] Set up testing database
  - Isolated test environment
  - Data seeding
  - Clean-up procedures
- [ ] Configure test pipeline
  - Unit test automation
  - Integration test suite
  - Performance testing
  - Coverage reporting
- [ ] Add E2E testing
  - User flow testing
  - API integration tests
  - UI component tests
  - Performance monitoring

## Dependencies
- AWS Parameter Store values need to be configured
- SNS topic subscriptions for notifications
- Slack webhook URL for notifications
- Database credentials in Secrets Manager

## Notes
- Infrastructure is ready for application development
- Focus on getting local development environment running first
- Prioritize core user flows over nice-to-have features
- Build with testing in mind from the start