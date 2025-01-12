-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable full text search for recipes
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Audit timestamps function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Users table
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMPTZ
);

CREATE TRIGGER users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE INDEX users_email_idx ON users (email);

-- User profiles table (one-to-one with users)
CREATE TABLE user_profiles (
    user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    height_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    target_weight_kg DECIMAL(5,2),
    activity_level TEXT CHECK (activity_level IN ('sedentary', 'light', 'moderate', 'very_active', 'extra_active')),
    dietary_preferences JSONB,
    macro_goals JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Recipes table with full text search
CREATE TABLE recipes (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    instructions TEXT NOT NULL,
    prep_time_minutes INTEGER NOT NULL,
    cook_time_minutes INTEGER NOT NULL,
    servings INTEGER NOT NULL,
    difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
    cuisine_type TEXT,
    meal_type TEXT[] NOT NULL,
    tags TEXT[],
    nutrition_per_serving JSONB NOT NULL,
    image_urls TEXT[],
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    search_vector tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(description, '')), 'B') ||
        setweight(to_tsvector('english', array_to_string(tags, ' ')), 'C')
    ) STORED
);

CREATE TRIGGER recipes_updated_at
    BEFORE UPDATE ON recipes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE INDEX recipes_search_idx ON recipes USING GIN (search_vector);
CREATE INDEX recipes_tags_idx ON recipes USING GIN (tags);
CREATE INDEX recipes_meal_type_idx ON recipes USING GIN (meal_type);

-- Ingredients table
CREATE TABLE ingredients (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    nutrition_per_100g JSONB NOT NULL,
    serving_units JSONB NOT NULL, -- e.g., {"g": 1, "cup": 128, "tbsp": 15}
    category TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER ingredients_updated_at
    BEFORE UPDATE ON ingredients
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE INDEX ingredients_category_idx ON ingredients (category);

-- Recipe ingredients junction with amounts
CREATE TABLE recipe_ingredients (
    recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id uuid REFERENCES ingredients(id),
    amount DECIMAL(8,2) NOT NULL,
    unit TEXT NOT NULL,
    notes TEXT,
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- Meal plans
CREATE TABLE meal_plans (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    name TEXT,
    macro_targets JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT date_range_check CHECK (end_date >= start_date)
);

CREATE TRIGGER meal_plans_updated_at
    BEFORE UPDATE ON meal_plans
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE INDEX meal_plans_user_date_idx ON meal_plans (user_id, start_date, end_date);

-- Meal plan items
CREATE TABLE meal_plan_items (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    meal_plan_id uuid REFERENCES meal_plans(id) ON DELETE CASCADE,
    recipe_id uuid REFERENCES recipes(id),
    day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6),
    meal_type TEXT NOT NULL,
    servings DECIMAL(3,1) NOT NULL DEFAULT 1.0,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER meal_plan_items_updated_at
    BEFORE UPDATE ON meal_plan_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE INDEX meal_plan_items_plan_idx ON meal_plan_items (meal_plan_id, day_of_week);

-- User favorite recipes
CREATE TABLE user_favorite_recipes (
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, recipe_id)
);

-- Shopping lists
CREATE TABLE shopping_lists (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    meal_plan_id uuid REFERENCES meal_plans(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER shopping_lists_updated_at
    BEFORE UPDATE ON shopping_lists
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Shopping list items
CREATE TABLE shopping_list_items (
    shopping_list_id uuid REFERENCES shopping_lists(id) ON DELETE CASCADE,
    ingredient_id uuid REFERENCES ingredients(id),
    amount DECIMAL(8,2) NOT NULL,
    unit TEXT NOT NULL,
    purchased BOOLEAN NOT NULL DEFAULT false,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (shopping_list_id, ingredient_id)
);

CREATE TRIGGER shopping_list_items_updated_at
    BEFORE UPDATE ON shopping_list_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Progress tracking
CREATE TABLE user_measurements (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    weight_kg DECIMAL(5,2),
    body_fat_percentage DECIMAL(4,1),
    measurements JSONB, -- For other measurements like waist, chest, etc.
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX user_measurements_date_idx ON user_measurements (user_id, date);

-- Meal logs for tracking actual consumption
CREATE TABLE meal_logs (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    meal_time TIMESTAMPTZ NOT NULL,
    meal_type TEXT NOT NULL,
    recipe_id uuid REFERENCES recipes(id),
    custom_meal_name TEXT,
    nutrition JSONB NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX meal_logs_user_date_idx ON meal_logs (user_id, date);
