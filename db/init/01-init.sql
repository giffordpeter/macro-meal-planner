-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- Create test database
CREATE DATABASE macro_meal_planner_test;

-- Create test user with limited privileges
CREATE USER test_user WITH PASSWORD 'test_password';
GRANT ALL PRIVILEGES ON DATABASE macro_meal_planner_test TO test_user;

-- Set up schema permissions
GRANT ALL ON SCHEMA public TO macro_user;
GRANT ALL ON SCHEMA public TO test_user;
