-- Recipe search with full-text search and macro filtering
CREATE OR REPLACE FUNCTION search_recipes(
    search_query TEXT,
    min_protein DECIMAL = NULL,
    max_calories DECIMAL = NULL,
    meal_types TEXT[] = NULL,
    tags TEXT[] = NULL
) RETURNS TABLE (
    id UUID,
    name TEXT,
    description TEXT,
    nutrition JSONB,
    search_rank FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.id,
        r.name,
        r.description,
        r.nutrition_per_serving,
        ts_rank(r.search_vector, to_tsquery('english', search_query)) as rank
    FROM recipes r
    WHERE 
        r.search_vector @@ to_tsquery('english', search_query)
        AND (min_protein IS NULL OR (r.nutrition_per_serving->>'protein')::decimal >= min_protein)
        AND (max_calories IS NULL OR (r.nutrition_per_serving->>'calories')::decimal <= max_calories)
        AND (meal_types IS NULL OR r.meal_type && meal_types)
        AND (tags IS NULL OR r.tags && tags)
    ORDER BY rank DESC;
END;
$$ LANGUAGE plpgsql;

-- Calculate weekly meal plan macros
CREATE OR REPLACE FUNCTION calculate_meal_plan_macros(meal_plan_id UUID)
RETURNS TABLE (
    day_of_week INTEGER,
    total_calories DECIMAL,
    total_protein DECIMAL,
    total_carbs DECIMAL,
    total_fat DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mpi.day_of_week,
        SUM((r.nutrition_per_serving->>'calories')::decimal * mpi.servings) as total_calories,
        SUM((r.nutrition_per_serving->>'protein')::decimal * mpi.servings) as total_protein,
        SUM((r.nutrition_per_serving->>'carbs')::decimal * mpi.servings) as total_carbs,
        SUM((r.nutrition_per_serving->>'fat')::decimal * mpi.servings) as total_fat
    FROM meal_plan_items mpi
    JOIN recipes r ON r.id = mpi.recipe_id
    WHERE mpi.meal_plan_id = meal_plan_id
    GROUP BY mpi.day_of_week
    ORDER BY mpi.day_of_week;
END;
$$ LANGUAGE plpgsql;

-- Generate shopping list from meal plan
CREATE OR REPLACE FUNCTION generate_shopping_list(meal_plan_id UUID)
RETURNS TABLE (
    ingredient_id UUID,
    ingredient_name TEXT,
    total_amount DECIMAL,
    unit TEXT,
    category TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH recipe_totals AS (
        SELECT 
            ri.ingredient_id,
            ri.unit,
            SUM(ri.amount * mpi.servings) as total_amount
        FROM meal_plan_items mpi
        JOIN recipe_ingredients ri ON ri.recipe_id = mpi.recipe_id
        WHERE mpi.meal_plan_id = meal_plan_id
        GROUP BY ri.ingredient_id, ri.unit
    )
    SELECT 
        rt.ingredient_id,
        i.name as ingredient_name,
        rt.total_amount,
        rt.unit,
        i.category
    FROM recipe_totals rt
    JOIN ingredients i ON i.id = rt.ingredient_id
    ORDER BY i.category, i.name;
END;
$$ LANGUAGE plpgsql;

-- Track user's macro progress over time
CREATE OR REPLACE FUNCTION user_macro_progress(
    user_id UUID,
    start_date DATE,
    end_date DATE
) RETURNS TABLE (
    date DATE,
    total_calories DECIMAL,
    total_protein DECIMAL,
    total_carbs DECIMAL,
    total_fat DECIMAL,
    goal_calories DECIMAL,
    goal_protein DECIMAL,
    goal_carbs DECIMAL,
    goal_fat DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    WITH daily_totals AS (
        SELECT 
            ml.date,
            SUM((ml.nutrition->>'calories')::decimal) as total_calories,
            SUM((ml.nutrition->>'protein')::decimal) as total_protein,
            SUM((ml.nutrition->>'carbs')::decimal) as total_carbs,
            SUM((ml.nutrition->>'fat')::decimal) as total_fat
        FROM meal_logs ml
        WHERE 
            ml.user_id = user_macro_progress.user_id
            AND ml.date BETWEEN start_date AND end_date
        GROUP BY ml.date
    )
    SELECT 
        dt.date,
        dt.total_calories,
        dt.total_protein,
        dt.total_carbs,
        dt.total_fat,
        (up.macro_goals->>'calories')::decimal as goal_calories,
        (up.macro_goals->>'protein')::decimal as goal_protein,
        (up.macro_goals->>'carbs')::decimal as goal_carbs,
        (up.macro_goals->>'fat')::decimal as goal_fat
    FROM daily_totals dt
    CROSS JOIN user_profiles up
    WHERE up.user_id = user_macro_progress.user_id
    ORDER BY dt.date;
END;
$$ LANGUAGE plpgsql;

-- Suggest recipes based on user preferences and remaining macros
CREATE OR REPLACE FUNCTION suggest_recipes(
    user_id UUID,
    meal_type TEXT,
    remaining_calories DECIMAL,
    remaining_protein DECIMAL
) RETURNS TABLE (
    recipe_id UUID,
    recipe_name TEXT,
    calories DECIMAL,
    protein DECIMAL,
    match_score DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    WITH user_prefs AS (
        SELECT 
            up.dietary_preferences,
            array_agg(DISTINCT r.id) as favorite_recipe_ids
        FROM user_profiles up
        LEFT JOIN user_favorite_recipes ufr ON ufr.user_id = up.user_id
        LEFT JOIN recipes r ON r.id = ufr.recipe_id
        WHERE up.user_id = suggest_recipes.user_id
        GROUP BY up.dietary_preferences
    )
    SELECT 
        r.id,
        r.name,
        (r.nutrition_per_serving->>'calories')::decimal as calories,
        (r.nutrition_per_serving->>'protein')::decimal as protein,
        (
            CASE WHEN r.id = ANY(up.favorite_recipe_ids) THEN 1.2 ELSE 1.0 END *
            (1.0 - ABS(remaining_calories - (r.nutrition_per_serving->>'calories')::decimal) / remaining_calories) *
            (1.0 - ABS(remaining_protein - (r.nutrition_per_serving->>'protein')::decimal) / remaining_protein)
        ) as match_score
    FROM recipes r
    CROSS JOIN user_prefs up
    WHERE 
        r.meal_type && ARRAY[meal_type]
        AND (r.nutrition_per_serving->>'calories')::decimal <= remaining_calories
        AND (r.nutrition_per_serving->>'protein')::decimal <= remaining_protein
        AND NOT EXISTS (
            SELECT 1 FROM meal_logs ml
            WHERE ml.user_id = suggest_recipes.user_id
              AND ml.recipe_id = r.id
              AND ml.date > CURRENT_DATE - INTERVAL '7 days'
        )
    ORDER BY match_score DESC
    LIMIT 5;
END;
$$ LANGUAGE plpgsql;
