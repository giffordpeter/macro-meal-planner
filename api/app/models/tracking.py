from datetime import date, datetime
from typing import Optional

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base

class DailyLog(Base):
    """Daily tracking of user's nutrition and weight."""
    
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"), nullable=False)
    date: Mapped[date] = mapped_column(nullable=False)
    
    # Daily totals
    total_calories: Mapped[int] = mapped_column(nullable=False, default=0)
    total_protein_g: Mapped[float] = mapped_column(nullable=False, default=0)
    total_carbs_g: Mapped[float] = mapped_column(nullable=False, default=0)
    total_fat_g: Mapped[float] = mapped_column(nullable=False, default=0)
    total_fiber_g: Mapped[Optional[float]] = mapped_column(nullable=True)
    
    # Weight tracking
    weight_kg: Mapped[Optional[float]] = mapped_column(nullable=True)
    body_fat_percentage: Mapped[Optional[float]] = mapped_column(nullable=True)
    
    # Wellness metrics
    water_ml: Mapped[Optional[int]] = mapped_column(nullable=True)
    sleep_hours: Mapped[Optional[float]] = mapped_column(nullable=True)
    energy_level: Mapped[Optional[int]] = mapped_column(nullable=True)  # 1-5 scale
    notes: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    
    # Relationships
    user = relationship("User", back_populates="daily_logs")
    meals = relationship("MealLog", back_populates="daily_log", cascade="all, delete-orphan")
    
    __table_args__ = (
        # Ensure one log per user per day
        sa.UniqueConstraint('user_id', 'date', name='uq_daily_log_user_date'),
    )

class MealLog(Base):
    """Individual meal tracking within a daily log."""
    
    daily_log_id: Mapped[int] = mapped_column(ForeignKey("dailylog.id"), nullable=False)
    meal_time: Mapped[datetime] = mapped_column(nullable=False)
    meal_type: Mapped[str] = mapped_column(String(50), nullable=False)  # breakfast, lunch, dinner, snack
    
    # If the meal is from a recipe
    recipe_id: Mapped[Optional[int]] = mapped_column(ForeignKey("recipe.id"), nullable=True)
    servings: Mapped[Optional[float]] = mapped_column(nullable=True)
    
    # Custom meal entry
    name: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    calories: Mapped[int] = mapped_column(nullable=False)
    protein_g: Mapped[float] = mapped_column(nullable=False)
    carbs_g: Mapped[float] = mapped_column(nullable=False)
    fat_g: Mapped[float] = mapped_column(nullable=False)
    fiber_g: Mapped[Optional[float]] = mapped_column(nullable=True)
    
    notes: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    
    # Relationships
    daily_log = relationship("DailyLog", back_populates="meals")
    recipe = relationship("Recipe")

class UserPreferences(Base):
    """User preferences for meal planning and tracking."""
    
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"), nullable=False, unique=True)
    
    # Meal schedule preferences
    breakfast_time: Mapped[Optional[str]] = mapped_column(String(5), nullable=True)  # HH:MM
    lunch_time: Mapped[Optional[str]] = mapped_column(String(5), nullable=True)  # HH:MM
    dinner_time: Mapped[Optional[str]] = mapped_column(String(5), nullable=True)  # HH:MM
    snack_times: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)  # Comma-separated HH:MM
    
    # Dietary preferences
    excluded_ingredients: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    preferred_cuisines: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    max_recipe_difficulty: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    max_prep_time_minutes: Mapped[Optional[int]] = mapped_column(nullable=True)
    
    # Meal planning preferences
    meal_prep_day: Mapped[Optional[int]] = mapped_column(nullable=True)  # 0-6 for Monday-Sunday
    shopping_day: Mapped[Optional[int]] = mapped_column(nullable=True)  # 0-6 for Monday-Sunday
    meals_per_day: Mapped[int] = mapped_column(nullable=False, default=3)
    snacks_per_day: Mapped[int] = mapped_column(nullable=False, default=2)
    
    # Notification preferences
    reminder_before_meal_minutes: Mapped[Optional[int]] = mapped_column(nullable=True)
    reminder_for_logging: Mapped[bool] = mapped_column(nullable=False, default=True)
    
    # Relationships
    user = relationship("User", back_populates="preferences")
