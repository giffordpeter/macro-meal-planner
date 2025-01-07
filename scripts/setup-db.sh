#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Function to create database
create_database() {
    local db_name=$1
    local env=$2
    
    echo "Creating database: $db_name for environment: $env"
    
    # Load environment variables
    if [ -f ".env.$env" ]; then
        source ".env.$env"
    else
        handle_error ".env.$env file not found"
    fi
    
    # Extract connection details from DATABASE_URL
    if [ -z "$DATABASE_URL" ]; then
        handle_error "DATABASE_URL not set in .env.$env"
    fi
    
    # Create database
    echo "Creating database $db_name..."
    createdb "$db_name" || handle_error "Failed to create database $db_name"
    
    echo "Database $db_name created successfully!"
}

# Function to push schema
push_schema() {
    local env=$1
    
    echo "Pushing schema for environment: $env"
    
    # Load environment variables
    if [ -f ".env.$env" ]; then
        source ".env.$env"
    else
        handle_error ".env.$env file not found"
    fi
    
    # Push schema using Prisma
    echo "Pushing schema..."
    npx prisma db push --accept-data-loss || handle_error "Failed to push schema"
    
    echo "Schema pushed successfully!"
}

# Function to run seed script
run_seed() {
    local env=$1
    
    echo "Running seed script for environment: $env"
    
    # Load environment variables
    if [ -f ".env.$env" ]; then
        source ".env.$env"
    else
        handle_error ".env.$env file not found"
    fi
    
    # Run seed script
    echo "Running seed script..."
    npx prisma db seed || handle_error "Failed to run seed script"
    
    echo "Seed completed successfully!"
}

# Main setup process
main() {
    local env=$1
    
    if [ -z "$env" ]; then
        handle_error "Environment not specified. Usage: ./setup-db.sh [development|test|production]"
    fi
    
    local db_name="macro_meal_planner_${env}"
    
    # Create database
    create_database "$db_name" "$env"
    
    # Push schema
    push_schema "$env"
    
    # Run seed script for development and test environments
    if [ "$env" != "production" ]; then
        run_seed "$env"
    fi
    
    echo "Database setup completed successfully for $env environment!"
}

# Run main function with environment argument
main "$1"
