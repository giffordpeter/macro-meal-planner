#!/bin/bash
set -e

# Load environment variables
if [ -f ".env" ]; then
    source .env
fi

# Check required environment variables
required_vars=("DB_HOST" "DB_NAME" "DB_USER" "DB_PASSWORD")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set"
        exit 1
    fi
done

# Default values
DB_PORT=${DB_PORT:-5432}
DB_SSL_MODE=${DB_SSL_MODE:-require}

# Function to execute migration
execute_migration() {
    local file=$1
    local version=$(basename "$file" | cut -d'_' -f1)
    
    echo "Applying migration: $file"
    
    # Begin transaction
    PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" <<EOF
    BEGIN;

    -- Check if migration has already been applied
    DO \$\$
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM schema_migrations WHERE version = '$version'
        ) THEN
            \i '$file'
            INSERT INTO schema_migrations (version) VALUES ('$version');
        END IF;
    END
    \$\$;

    COMMIT;
EOF
}

# Create schema_migrations table if it doesn't exist
PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" <<EOF
    CREATE TABLE IF NOT EXISTS schema_migrations (
        version TEXT PRIMARY KEY,
        applied_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
EOF

# Get list of migration files
migration_files=($(ls -v db/migrations/V*__*.sql))

# Apply each migration in order
for file in "${migration_files[@]}"; do
    execute_migration "$file"
done

echo "Migrations completed successfully"
