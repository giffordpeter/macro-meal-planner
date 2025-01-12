# Macro Meal Planner

A comprehensive meal planning application that helps users create personalized meal plans based on their macro-nutrient goals.

## Features

- 🍽️ Personalized meal planning
- 📊 Macro tracking
- 🔍 Recipe search and management
- 📱 Responsive web interface
- 📈 Progress tracking
- 🛒 Shopping list generation

## Tech Stack

- **Frontend**: Next.js 14 with TypeScript
- **Backend**: FastAPI with Python 3.11
- **Database**: PostgreSQL 15
- **Infrastructure**: AWS (ECS, RDS, CodePipeline)
- **CI/CD**: AWS CodePipeline, GitHub Actions

## Getting Started

### Prerequisites

- Python 3.11+
- Node.js 18+
- Docker
- AWS CLI
- Terraform

### Local Development

1. Clone the repository:
```bash
git clone https://github.com/yourusername/macro-meal-planner.git
cd macro-meal-planner
```

2. Set up the backend:
```bash
cd api
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
pip install -r requirements-dev.txt
```

3. Set up the database:
```bash
docker-compose up -d db
alembic upgrade head
python scripts/seed.py
```

4. Set up the frontend:
```bash
cd frontend
npm install
npm run dev
```

5. Create a `.env` file:
```bash
cp .env.example .env
# Edit .env with your local settings
```

### Running Tests

```bash
# Backend tests
cd api
pytest

# Frontend tests
cd frontend
npm test
```

## Infrastructure

Our infrastructure is managed with Terraform and deployed on AWS:

- VPC with public/private subnets
- ECS Fargate for container orchestration
- RDS PostgreSQL for database
- CodePipeline for CI/CD
- CloudWatch for monitoring

### Deployment

1. Initialize Terraform:
```bash
cd terraform/environments/staging
terraform init
```

2. Apply infrastructure:
```bash
terraform apply
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Project Structure

```
.
├── api/                # Backend FastAPI application
│   ├── app/           # Application code
│   ├── tests/         # Test suite
│   └── alembic/       # Database migrations
├── frontend/          # Next.js frontend
├── terraform/         # Infrastructure as Code
├── db/                # Database scripts and schemas
└── docs/             # Documentation
```

## Documentation

- [API Documentation](docs/api.md)
- [Database Schema](docs/schema.md)
- [Development Guide](docs/development.md)
- [Deployment Guide](docs/deployment.md)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
