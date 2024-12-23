#!/bin/bash

# Initialize the database
python -m flask db upgrade || echo "Database migration failed but continuing..."

# Start Gunicorn with environment variables
PORT=${PORT:-8000}
WORKERS=${WORKERS:-4}
TIMEOUT=${TIMEOUT:-120}

exec gunicorn --bind=0.0.0.0:$PORT --workers=$WORKERS --timeout=$TIMEOUT run:app
