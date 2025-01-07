#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Function to validate environment
validate_environment() {
    if [ -z "$DATABASE_URL" ]; then
        handle_error "DATABASE_URL is not set"
    fi
}

# Function to check if we're in production
is_production() {
    [ "$NODE_ENV" = "production" ]
}

# Function to create backup (only in production)
create_backup() {
    if is_production; then
        echo "Creating database backup..."
        # Add your backup command here
        # pg_dump "$DATABASE_URL" > "backup_$(date +%Y%m%d_%H%M%S).sql"
    fi
}

# Main migration process
main() {
    validate_environment

    # Create backup in production
    create_backup

    # Run migration
    if is_production; then
        echo "Running production migration..."
        npx prisma migrate deploy || handle_error "Migration failed"
    else
        echo "Running development migration..."
        npx prisma migrate dev || handle_error "Migration failed"
    fi

    # Generate Prisma Client
    echo "Generating Prisma Client..."
    npx prisma generate || handle_error "Client generation failed"

    echo "Migration completed successfully!"
}

# Run the main function
main
