# Development Guide

## Development Environment Setup

### Required Tools

- **Python 3.11+**: For backend development
- **Node.js 18+**: For frontend development
- **Docker**: For local services
- **AWS CLI**: For infrastructure management
- **Terraform**: For infrastructure as code
- **PostgreSQL Client**: For database management

### IDE Setup

#### VSCode Extensions
- Python
- Pylance
- ESLint
- Prettier
- Docker
- HashiCorp Terraform
- GitLens

### Environment Configuration

1. **Backend Environment**
   ```bash
   cd api
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   pip install -r requirements-dev.txt
   ```

2. **Frontend Environment**
   ```bash
   cd frontend
   npm install
   ```

3. **Environment Variables**
   ```bash
   cp .env.example .env
   # Edit .env with your local settings
   ```

## Development Workflow

### Git Workflow

1. **Branch Naming**
   - Feature: `feature/description`
   - Bug Fix: `fix/description`
   - Hotfix: `hotfix/description`
   - Release: `release/version`

2. **Commit Messages**
   ```
   type(scope): description

   [optional body]

   [optional footer]
   ```
   Types: feat, fix, docs, style, refactor, test, chore

### Code Style

#### Python
- Follow PEP 8
- Use Black for formatting
- Use isort for import sorting
- Maximum line length: 88 characters

#### TypeScript/JavaScript
- Use ESLint with Airbnb config
- Use Prettier for formatting
- Maximum line length: 100 characters

### Testing

#### Backend Tests
```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app

# Run specific test file
pytest tests/test_file.py
```

#### Frontend Tests
```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test file
npm test -- path/to/test
```

### Database Migrations

1. **Create Migration**
   ```bash
   cd api
   alembic revision -m "description"
   ```

2. **Apply Migration**
   ```bash
   alembic upgrade head
   ```

3. **Rollback Migration**
   ```bash
   alembic downgrade -1
   ```

### Local Development

1. **Start Services**
   ```bash
   docker-compose up -d
   ```

2. **Run Backend**
   ```bash
   cd api
   uvicorn app.main:app --reload
   ```

3. **Run Frontend**
   ```bash
   cd frontend
   npm run dev
   ```

### API Documentation

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Deployment

### Staging Deployment
```bash
# Deploy infrastructure
cd terraform/environments/staging
terraform apply

# Deploy application
git push origin develop
```

### Production Deployment
```bash
# Create release
git checkout main
git merge develop
git tag v1.x.x
git push origin main --tags
```

## Monitoring and Debugging

### Local Debugging
- Backend: Use VS Code debugger with Python extension
- Frontend: Use Chrome DevTools with React Developer Tools

### Production Monitoring
- CloudWatch Dashboards
- CloudWatch Logs
- RDS Performance Insights
- Application metrics in Grafana

## Security

### Security Practices
- No secrets in code
- Use AWS Secrets Manager
- Regular dependency updates
- Security scanning in CI/CD
- Input validation
- HTTPS everywhere
- JWT token authentication
- Rate limiting

### Vulnerability Reporting
Report security vulnerabilities to security@yourdomain.com
