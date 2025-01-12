from typing import List, Optional

from sqlalchemy import ForeignKey, String, Table
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base

# Association tables
recipe_ingredients = Table(
    "recipe_ingredients",
    Base.metadata,
    mapped_column("recipe_id", ForeignKey("recipe.id"), primary_key=True),
    mapped_column("ingredient_id", ForeignKey("ingredient.id"), primary_key=True),
    mapped_column("amount", String(50), nullable=False),
)

user_favorite_recipes = Table(
    "user_favorite_recipes",
    Base.metadata,
    mapped_column("user_id", ForeignKey("user.id"), primary_key=True),
    mapped_column("recipe_id", ForeignKey("recipe.id"), primary_key=True),
)

class Recipe(Base):
    """Recipe model containing cooking instructions and nutritional information."""
    
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    instructions: Mapped[str] = mapped_column(String(5000), nullable=False)
    prep_time_minutes: Mapped[int] = mapped_column(nullable=False)
    cook_time_minutes: Mapped[int] = mapped_column(nullable=False)
    servings: Mapped[int] = mapped_column(nullable=False)
    
    # Nutritional information (per serving)
    calories: Mapped[int] = mapped_column(nullable=False)
    protein_g: Mapped[float] = mapped_column(nullable=False)
    carbs_g: Mapped[float] = mapped_column(nullable=False)
    fat_g: Mapped[float] = mapped_column(nullable=False)
    fiber_g: Mapped[Optional[float]] = mapped_column(nullable=True)
    
    # Recipe metadata
    cuisine_type: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    meal_type: Mapped[str] = mapped_column(String(50), nullable=False)  # breakfast, lunch, dinner, snack
    difficulty: Mapped[str] = mapped_column(String(20), nullable=False)  # easy, medium, hard
    
    # Image URL (can be extended to support multiple images)
    image_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    
    # Relationships
    ingredients: Mapped[List["Ingredient"]] = relationship(
        secondary=recipe_ingredients,
        back_populates="recipes"
    )
    favorited_by = relationship(
        "User",
        secondary=user_favorite_recipes,
        back_populates="favorite_recipes"
    )
    meal_plans = relationship("MealPlanRecipe", back_populates="recipe")
    
    def __repr__(self) -> str:
        return f"Recipe(id={self.id}, name={self.name}, calories={self.calories})"

class Ingredient(Base):
    """Ingredient model with nutritional information per 100g."""
    
    name: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    calories_per_100g: Mapped[int] = mapped_column(nullable=False)
    protein_g_per_100g: Mapped[float] = mapped_column(nullable=False)
    carbs_g_per_100g: Mapped[float] = mapped_column(nullable=False)
    fat_g_per_100g: Mapped[float] = mapped_column(nullable=False)
    fiber_g_per_100g: Mapped[Optional[float]] = mapped_column(nullable=True)
    
    # Common measurement unit (e.g., grams, cups, tablespoons)
    default_unit: Mapped[str] = mapped_column(String(20), nullable=False)
    
    # Relationships
    recipes: Mapped[List[Recipe]] = relationship(
        secondary=recipe_ingredients,
        back_populates="ingredients"
    )
    
    def __repr__(self) -> str:
        return f"Ingredient(id={self.id}, name={self.name})"
