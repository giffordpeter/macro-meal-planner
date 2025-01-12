# Macro Meal Planner - Project Todo

## Completed Items
- [x] Set up local development environment with Docker Compose
- [x] Configure development tools and scripts
- [x] Create FastAPI project structure
- [x] Set up core modules (config, database, security, etc.)
- [x] Configure logging and middleware
- [x] Set up API routing structure

## Immediate Tasks (Next 2 Weeks)

### Week 1: Database and Authentication
1. Database Models
   - [ ] Create User model and schema
   - [ ] Create Recipe model and schema
   - [ ] Create MealPlan model and schema
   - [ ] Create Ingredient model and schema
   - [ ] Set up model relationships

2. Authentication Implementation
   - [ ] Create user registration endpoint
   - [ ] Implement login endpoint
   - [ ] Add password reset functionality
   - [ ] Set up email verification
   - [ ] Implement refresh token logic

3. Core API Features
   - [ ] User profile CRUD operations
   - [ ] Basic recipe management
   - [ ] Ingredient database setup
   - [ ] Initial meal plan structure

### Week 2: Feature Development
1. Recipe Management
   - [ ] Recipe CRUD operations
   - [ ] Recipe search and filtering
   - [ ] Recipe categorization
   - [ ] Nutrition calculation

2. Meal Planning
   - [ ] Create meal plan templates
   - [ ] Weekly meal planning
   - [ ] Shopping list generation
   - [ ] Macro calculation

3. Frontend Development
   - [ ] Set up Next.js project
   - [ ] Create component library
   - [ ] Implement authentication UI
   - [ ] Build recipe management interface

## Current Focus Areas

### 1. Database Development
- [ ] Write database migrations
  - Initial schema setup
  - User tables
  - Recipe tables
  - Meal plan tables
- [ ] Write database testing framework
  - Unit tests for models
  - Integration tests for queries
  - Test data factories
- [ ] Document database schema
  - Entity relationships
  - Indexing strategy
  - Query optimization

### 2. API Development
- [ ] Implement core endpoints
  - User management
  - Recipe CRUD
  - Meal plan operations
- [ ] Add API documentation
  - OpenAPI specs
  - Usage examples
  - Rate limiting docs
- [ ] Set up testing framework
  - Unit tests
  - Integration tests
  - API documentation tests

### 3. Frontend Development
- [ ] Design system implementation
  - Color scheme
  - Typography
  - Component patterns
- [ ] Core features
  - Recipe browser
  - Meal planner
  - Shopping lists
- [ ] User experience
  - Responsive design
  - Accessibility
  - Performance optimization

## Dependencies
- AWS Parameter Store values need to be configured
- SNS topic subscriptions for notifications
- Slack webhook URL for notifications
- Database credentials in Secrets Manager

## Notes
- Infrastructure and API structure are ready
- Next focus: Database models and authentication
- Frontend development can begin after core API endpoints
- Consider adding API versioning strategy
- Plan for data migration strategy

## Stopping Point (2025-01-12)
- Completed FastAPI project structure setup
- Core modules and middleware in place
- Next step: Implement database models and schemas
- Following: Authentication endpoints and core API features