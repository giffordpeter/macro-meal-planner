#!/bin/bash

# Exit on error
set -e

echo "Setting up development environment..."

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
fi

# Make sure Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start services
echo "Starting services..."
docker-compose up -d

# Wait for database to be ready
echo "Waiting for database to be ready..."
until docker-compose exec -T db pg_isready -U macro_user -d macro_meal_planner; do
    echo "Database is unavailable - sleeping"
    sleep 1
done

# Run database migrations
echo "Running database migrations..."
docker-compose exec api alembic upgrade head

# Install frontend dependencies
echo "Installing frontend dependencies..."
cd frontend && npm install

echo "Development environment setup complete!"
echo "API is running at: http://localhost:8000"
echo "Frontend is running at: http://localhost:3000"
echo "Database is available at: localhost:5432"
echo "LocalStack is available at: http://localhost:4566"
