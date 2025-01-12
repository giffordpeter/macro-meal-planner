from datetime import date, datetime
from typing import List, Optional

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base

class MealPlan(Base):
    """Weekly meal plan for a user."""
    
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"), nullable=False)
    start_date: Mapped[date] = mapped_column(nullable=False)
    end_date: Mapped[date] = mapped_column(nullable=False)
    name: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    
    # Target macros for the meal plan (if different from user's default goals)
    daily_calories: Mapped[Optional[int]] = mapped_column(nullable=True)
    protein_goal_g: Mapped[Optional[int]] = mapped_column(nullable=True)
    carbs_goal_g: Mapped[Optional[int]] = mapped_column(nullable=True)
    fat_goal_g: Mapped[Optional[int]] = mapped_column(nullable=True)
    
    # Relationships
    user = relationship("User", back_populates="meal_plans")
    recipes = relationship("MealPlanRecipe", back_populates="meal_plan", cascade="all, delete-orphan")
    
    def __repr__(self) -> str:
        return f"MealPlan(id={self.id}, user_id={self.user_id}, start_date={self.start_date})"

class MealPlanRecipe(Base):
    """Association between meal plans and recipes, including day and meal type."""
    
    meal_plan_id: Mapped[int] = mapped_column(ForeignKey("mealplan.id"), nullable=False)
    recipe_id: Mapped[int] = mapped_column(ForeignKey("recipe.id"), nullable=False)
    day_of_week: Mapped[int] = mapped_column(nullable=False)  # 0-6 for Monday-Sunday
    meal_type: Mapped[str] = mapped_column(String(50), nullable=False)  # breakfast, lunch, dinner, snack
    servings: Mapped[float] = mapped_column(nullable=False, default=1.0)
    notes: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    
    # Relationships
    meal_plan = relationship("MealPlan", back_populates="recipes")
    recipe = relationship("Recipe", back_populates="meal_plans")
    
    def __repr__(self) -> str:
        return f"MealPlanRecipe(meal_plan_id={self.meal_plan_id}, recipe_id={self.recipe_id}, day={self.day_of_week})"
