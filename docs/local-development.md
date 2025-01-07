# Local Development Setup

## Prerequisites

- Node.js 18 or later
- PostgreSQL 15.10
- npm or yarn

## Initial Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/macro-meal-planner.git
cd macro-meal-planner
```

2. Run the local development setup script:
```bash
./scripts/setup-local-dev.sh
```

This script will:
- Check for required dependencies
- Set up a local PostgreSQL database
- Install npm dependencies
- Create a local environment file
- Run database migrations
- Build the application

3. Update your local environment variables:
Edit `.env.local` and add your credentials for:
- GitHub OAuth (for authentication)
- OpenAI API key (for meal suggestions)

## Development

1. Start the development server:
```bash
npm run dev
```

2. Visit http://localhost:3000 in your browser

## Database Management

The local database is set up with:
- Database Name: macro_meal_planner_dev
- User: macro_user
- Port: 5432

To reset the database:
```bash
./scripts/setup-local-db.sh
```

## Testing

Run tests locally:
```bash
# Run unit tests
npm run test:unit

# Run integration tests
npm run test:integration

# Run all tests
npm test
```

## Troubleshooting

1. Database Connection Issues:
   - Ensure PostgreSQL is running
   - Check database credentials in `.env.local`
   - Try resetting the database with `./scripts/setup-local-db.sh`

2. Build Errors:
   - Clear the build cache: `npm run clean`
   - Remove node_modules: `rm -rf node_modules && npm install`

3. Authentication Issues:
   - Verify GitHub OAuth credentials in `.env.local`
   - Ensure `NEXTAUTH_URL` matches your local development URL
