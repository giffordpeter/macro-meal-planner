#!/bin/bash

# Exit on error
set -e

# Database configuration
DB_NAME="macro_meal_planner_dev"
DB_USER="macro_user"
DB_PASSWORD="local_dev_password"
DB_PORT=5432

# Check if PostgreSQL is running
if ! pg_isready; then
    echo "PostgreSQL is not running. Please start PostgreSQL first."
    exit 1
fi

# Create database user if it doesn't exist
if ! psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
    echo "Creating database user: $DB_USER"
    psql postgres -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
fi

# Create database if it doesn't exist
if ! psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "Creating database: $DB_NAME"
    createdb $DB_NAME -O $DB_USER
fi

# Grant privileges
echo "Granting privileges to $DB_USER on $DB_NAME"
psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER;"
psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;"

echo "Local database setup complete!"
echo "Connection string: postgresql://$DB_USER:$DB_PASSWORD@localhost:$DB_PORT/$DB_NAME"
