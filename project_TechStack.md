# Macro Meal Planner - Technical Stack

## Frontend Stack

### Core Framework
- **Next.js 14**: Full-stack React framework
  - App Router for routing
  - Server Components for improved performance
  - API Routes for backend functionality
  - Server Actions for form handling
- **React 18**: UI library
  - Server Components
  - Concurrent Features
  - Suspense

### UI & Styling
- **Tailwind CSS**: Utility-first CSS framework
- **Shadcn/ui**: Component library
  - Built on Radix UI primitives
  - Tailwind CSS integration
  - Fully accessible components
- **Recharts**: Data visualization
  - React integration
  - Responsive charts
  - Custom styling support

### State Management & Data Fetching
- **Zustand**: Client-state management
  - Lightweight
  - TypeScript support
  - Middleware support
- **React Query**: Server-state management
  - Caching
  - Background updates
  - Optimistic updates
  - Infinite loading

### Forms & Validation
- **React Hook Form**: Form management
  - Performance focused
  - Uncontrolled components
  - Field arrays support
- **Zod**: Schema validation
  - TypeScript integration
  - Runtime validation
  - API input validation

## Backend Stack

### API Layer
- **Next.js API Routes**: Primary API endpoints
  - API route handlers
  - Middleware support
  - Edge runtime support
- **tRPC**: Type-safe API layer (optional)
  - End-to-end type safety
  - Automatic API documentation
  - Integrated with React Query

### Authentication
- **NextAuth.js**: Authentication
  - Multiple providers
  - JWT sessions
  - Database session support
  - Role-based access control
- **Azure Identity**: Cloud authentication
  - Managed identities
  - Token management
- **Azure Key Vault**: Secret management
  - Secure secret storage
  - Secret rotation
  - Access policies

### Database
- **PostgreSQL**: Primary database
  - Development: Local PostgreSQL instance
  - Test: Local PostgreSQL instance
  - Production: Azure Database for PostgreSQL
    - Flexible Server deployment
    - Automated backups
    - Point-in-time recovery
    - SSL encryption
    - Connection pooling
  - JSONB for flexible data storage
  - Full-text search capabilities
  - Complex query support
- **Prisma**: ORM (`@prisma/client` v6.1.0)
  - Type-safe database access
  - Schema management
  - Database migrations
  - Query optimization
  - Connection pooling
  - Environment-specific configurations

### Caching
- **Redis**: Caching layer
  - Session storage
  - Rate limiting
  - Real-time features
  - Leaderboards

### AI/ML Integration
- **Azure OpenAI Service**: AI capabilities
  - Recipe generation
  - Meal planning optimization
  - Natural language processing
- **TensorFlow.js**: Client-side ML (if needed)
  - Model inference
  - Real-time predictions

## DevOps & Infrastructure

### Cloud Platform
- **Azure**: Cloud provider
  - App Service for Next.js
  - Azure Database for PostgreSQL
  - Azure Cache for Redis
  - Azure OpenAI Service
  - Azure Key Vault
  - Azure CDN
  - Azure Container Registry

### CI/CD
- **GitHub Actions**: Automation
  - Automated testing
  - Deployment automation
  - Environment management
  - Security scanning

### Monitoring & Analytics
- **Azure Application Insights**: Application monitoring
  - Performance monitoring
  - Error tracking
  - User analytics
- **Grafana**: Metrics visualization
- **Prometheus**: Metrics collection

### Development Tools
- **TypeScript 5**: Programming language
  - Strict type checking
  - ESNext features
  - Custom tsconfig for different environments
  - Type definitions:
    - `@types/node`
    - `@types/react`
    - `@types/react-dom`
    - `@types/bcryptjs`
    - `@types/jest`
- **Environment Management**
  - `dotenv-cli`: Environment file handling
  - Multiple environment configurations
  - Environment-specific database URLs
  - Connection pool settings
  - Security configurations
- **ESLint**: Code linting
  - Next.js configuration
  - TypeScript support
- **Prettier**: Code formatting
- **Husky**: Git hooks
- **Jest 29**: Testing framework
  - `ts-jest`: TypeScript support
  - `@types/jest`: TypeScript definitions
  - Test environments: Unit, Integration, Database
  - Async test support
  - Custom test configuration
- **Cypress**: E2E testing
- **MSW**: API mocking

### Testing
- **Database Testing**
  - Isolated test database
  - CRUD operation validation
  - Relationship testing
  - Cascade deletion verification
  - Connection pool testing

### Scripts and Automation
- **Database Management**
  - `db:migrate:dev`: Development migrations
  - `db:migrate:test`: Test migrations
  - `db:migrate:prod`: Production migrations
  - `db:reset`: Database reset
  - `db:generate`: Prisma client generation
- **Testing**
  - `test`: Run all tests
  - `test:watch`: Watch mode
  - `test:db`: Database tests
- **Development**
  - `dev`: Next.js development
  - `build`: Production build
  - `start`: Production server
  - `lint`: Code linting

## Security
- **bcryptjs**: Password hashing
- **Helmet.js**: Security headers
- **Rate limiting**: API protection
- **CORS**: Cross-origin security
- **Azure Key Vault**: Secrets management
- **Content Security Policy**: XSS protection

## Performance Optimization
- **Next.js Image Optimization**
- **Edge Caching**
- **CDN Integration**
- **Database Indexing**
- **Query Optimization**

## Development Workflow
- **Git Flow**: Branch management
- **Conventional Commits**: Commit messages
- **Semantic Versioning**: Version management
- **Code Review Process**
- **Documentation Standards**
