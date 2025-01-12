# Database Management

This directory contains database migrations and management scripts for the Macro Meal Planner project.

## Structure

```
db/
├── migrations/       # SQL migration files
├── seeds/           # Seed data for development
├── scripts/         # Database management scripts
└── schemas/         # Schema documentation
```

## Migration Naming Convention

Migrations are versioned using the following format:
`V{version}__{description}.sql`

Example: `V1__initial_schema.sql`

## Environment Setup

The database connection is configured using environment variables:
- `DB_HOST`: Database host
- `DB_PORT`: Database port (default: 5432)
- `DB_NAME`: Database name
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password
- `DB_SSL_MODE`: SSL mode (disable, require, verify-ca, verify-full)

## Usage

1. Create a new migration:
   ```bash
   ./scripts/create-migration.sh "description"
   ```

2. Apply migrations:
   ```bash
   ./scripts/migrate.sh
   ```

3. Rollback last migration:
   ```bash
   ./scripts/rollback.sh
   ```

4. Seed development data:
   ```bash
   ./scripts/seed-dev.sh
   ```
