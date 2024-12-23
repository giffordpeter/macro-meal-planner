#!/bin/bash

# Initialize the database
python -m flask db upgrade

# Start Gunicorn
exec gunicorn --bind=0.0.0.0:$PORT run:app --timeout 600
