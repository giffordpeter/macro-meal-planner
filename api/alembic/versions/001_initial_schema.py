"""initial schema

Revision ID: 001
Revises: 
Create Date: 2025-01-12 00:30:29.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = '001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

def upgrade() -> None:
    # Create user table
    op.create_table(
        'user',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('email', sa.String(length=255), nullable=False),
        sa.Column('hashed_password', sa.String(length=255), nullable=False),
        sa.Column('full_name', sa.String(length=255), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.Column('is_superuser', sa.Boolean(), nullable=False),
        sa.Column('height_cm', sa.Float(), nullable=True),
        sa.Column('weight_kg', sa.Float(), nullable=True),
        sa.Column('target_weight_kg', sa.Float(), nullable=True),
        sa.Column('activity_level', sa.String(length=50), nullable=True),
        sa.Column('dietary_restrictions', sa.String(length=255), nullable=True),
        sa.Column('daily_calories', sa.Integer(), nullable=True),
        sa.Column('protein_goal_g', sa.Integer(), nullable=True),
        sa.Column('carbs_goal_g', sa.Integer(), nullable=True),
        sa.Column('fat_goal_g', sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint('id', name=op.f('pk_user')),
    )
    op.create_index(op.f('ix_user_email'), 'user', ['email'], unique=True)

    # Create ingredient table
    op.create_table(
        'ingredient',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('calories_per_100g', sa.Integer(), nullable=False),
        sa.Column('protein_g_per_100g', sa.Float(), nullable=False),
        sa.Column('carbs_g_per_100g', sa.Float(), nullable=False),
        sa.Column('fat_g_per_100g', sa.Float(), nullable=False),
        sa.Column('fiber_g_per_100g', sa.Float(), nullable=True),
        sa.Column('default_unit', sa.String(length=20), nullable=False),
        sa.PrimaryKeyConstraint('id', name=op.f('pk_ingredient')),
        sa.UniqueConstraint('name', name=op.f('uq_ingredient_name')),
    )

    # Create recipe table
    op.create_table(
        'recipe',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('description', sa.String(length=1000), nullable=True),
        sa.Column('instructions', sa.String(length=5000), nullable=False),
        sa.Column('prep_time_minutes', sa.Integer(), nullable=False),
        sa.Column('cook_time_minutes', sa.Integer(), nullable=False),
        sa.Column('servings', sa.Integer(), nullable=False),
        sa.Column('calories', sa.Integer(), nullable=False),
        sa.Column('protein_g', sa.Float(), nullable=False),
        sa.Column('carbs_g', sa.Float(), nullable=False),
        sa.Column('fat_g', sa.Float(), nullable=False),
        sa.Column('fiber_g', sa.Float(), nullable=True),
        sa.Column('cuisine_type', sa.String(length=100), nullable=True),
        sa.Column('meal_type', sa.String(length=50), nullable=False),
        sa.Column('difficulty', sa.String(length=20), nullable=False),
        sa.Column('image_url', sa.String(length=500), nullable=True),
        sa.PrimaryKeyConstraint('id', name=op.f('pk_recipe')),
    )

    # Create meal plan table
    op.create_table(
        'mealplan',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('start_date', sa.Date(), nullable=False),
        sa.Column('end_date', sa.Date(), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=True),
        sa.Column('notes', sa.String(length=1000), nullable=True),
        sa.Column('daily_calories', sa.Integer(), nullable=True),
        sa.Column('protein_goal_g', sa.Integer(), nullable=True),
        sa.Column('carbs_goal_g', sa.Integer(), nullable=True),
        sa.Column('fat_goal_g', sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['user.id'], name=op.f('fk_mealplan_user_id_user')),
        sa.PrimaryKeyConstraint('id', name=op.f('pk_mealplan')),
    )

    # Create association tables
    op.create_table(
        'mealplanrecipe',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('meal_plan_id', sa.Integer(), nullable=False),
        sa.Column('recipe_id', sa.Integer(), nullable=False),
        sa.Column('day_of_week', sa.Integer(), nullable=False),
        sa.Column('meal_type', sa.String(length=50), nullable=False),
        sa.Column('servings', sa.Float(), nullable=False),
        sa.Column('notes', sa.String(length=500), nullable=True),
        sa.ForeignKeyConstraint(['meal_plan_id'], ['mealplan.id'], name=op.f('fk_mealplanrecipe_meal_plan_id_mealplan')),
        sa.ForeignKeyConstraint(['recipe_id'], ['recipe.id'], name=op.f('fk_mealplanrecipe_recipe_id_recipe')),
        sa.PrimaryKeyConstraint('id', name=op.f('pk_mealplanrecipe')),
    )

    op.create_table(
        'recipe_ingredients',
        sa.Column('recipe_id', sa.Integer(), nullable=False),
        sa.Column('ingredient_id', sa.Integer(), nullable=False),
        sa.Column('amount', sa.String(length=50), nullable=False),
        sa.ForeignKeyConstraint(['ingredient_id'], ['ingredient.id'], name=op.f('fk_recipe_ingredients_ingredient_id_ingredient')),
        sa.ForeignKeyConstraint(['recipe_id'], ['recipe.id'], name=op.f('fk_recipe_ingredients_recipe_id_recipe')),
        sa.PrimaryKeyConstraint('recipe_id', 'ingredient_id', name=op.f('pk_recipe_ingredients')),
    )

    op.create_table(
        'user_favorite_recipes',
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('recipe_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['recipe_id'], ['recipe.id'], name=op.f('fk_user_favorite_recipes_recipe_id_recipe')),
        sa.ForeignKeyConstraint(['user_id'], ['user.id'], name=op.f('fk_user_favorite_recipes_user_id_user')),
        sa.PrimaryKeyConstraint('user_id', 'recipe_id', name=op.f('pk_user_favorite_recipes')),
    )

def downgrade() -> None:
    op.drop_table('user_favorite_recipes')
    op.drop_table('recipe_ingredients')
    op.drop_table('mealplanrecipe')
    op.drop_table('mealplan')
    op.drop_table('recipe')
    op.drop_table('ingredient')
    op.drop_index(op.f('ix_user_email'), table_name='user')
    op.drop_table('user')
