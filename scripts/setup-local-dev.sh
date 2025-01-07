#!/bin/bash

# Exit on error
set -e

echo "Setting up local development environment..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "PostgreSQL is not installed. Please install it first:"
    echo "brew install postgresql@15"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install it first:"
    echo "brew install node@18"
    exit 1
fi

# Create necessary directories
mkdir -p scripts

# Make database setup script executable
chmod +x scripts/setup-local-db.sh

# Setup local database
./scripts/setup-local-db.sh

# Install dependencies
echo "Installing npm dependencies..."
npm install

# Setup environment file if it doesn't exist
if [ ! -f .env.local ]; then
    echo "Creating .env.local from template..."
    cp env.local.example .env.local
    echo "Please update .env.local with your credentials"
fi

# Run database migrations
echo "Running database migrations..."
npx prisma migrate dev

# Build the application
echo "Building the application..."
npm run build

echo "Local development setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env.local with your credentials"
echo "2. Start the development server: npm run dev"
echo "3. Visit http://localhost:3000"
