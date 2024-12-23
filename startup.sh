#!/bin/bash

# Get port from environment variable or use default
PORT=${PORT:-8000}

# Start Gunicorn
exec gunicorn --bind=0.0.0.0:$PORT --timeout 600 run:app
