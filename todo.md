# Macro Meal Planner - Project Todo

## Current Focus Areas

### 1. Database Development
- [ ] Create initial seed data
  - Sample users with profiles
  - Base recipe collection
  - Common ingredients database
  - Example meal plans
- [ ] Set up development database
  - Local development setup
  - Testing database configuration
  - Data reset procedures
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
- [ ] Set up FastAPI project structure
  - Project layout
  - Configuration management
  - Dependency injection
  - Error handling
- [ ] Implement authentication
  - JWT implementation
  - Role-based access control
  - Session management
  - Password reset flow
- [ ] Create user management endpoints
  - Registration
  - Profile management
  - Preference settings
  - Activity tracking
- [ ] Implement meal planning endpoints
  - Recipe CRUD
  - Meal plan generation
  - Shopping list creation
  - Nutrition tracking

### 3. Frontend Development
- [ ] Set up Next.js project
  - Project structure
  - Build configuration
  - Development environment
  - Type safety setup
- [ ] Create component library
  - Design system
  - Common components
  - Form elements
  - Layout components
- [ ] Implement authentication UI
  - Login/Register forms
  - Password reset
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