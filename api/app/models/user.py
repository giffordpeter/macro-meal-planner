from datetime import datetime
from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base

class User(Base):
    """User model for authentication and profile information."""
    
    email: Mapped[str] = mapped_column(
        String(255), unique=True, index=True, nullable=False
    )
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    full_name: Mapped[str] = mapped_column(String(255), nullable=False)
    is_active: Mapped[bool] = mapped_column(default=True, nullable=False)
    is_superuser: Mapped[bool] = mapped_column(default=False, nullable=False)
    
    # Profile information
    height_cm: Mapped[Optional[float]] = mapped_column(nullable=True)
    weight_kg: Mapped[Optional[float]] = mapped_column(nullable=True)
    target_weight_kg: Mapped[Optional[float]] = mapped_column(nullable=True)
    activity_level: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    dietary_restrictions: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    
    # Macro goals
    daily_calories: Mapped[Optional[int]] = mapped_column(nullable=True)
    protein_goal_g: Mapped[Optional[int]] = mapped_column(nullable=True)
    carbs_goal_g: Mapped[Optional[int]] = mapped_column(nullable=True)
    fat_goal_g: Mapped[Optional[int]] = mapped_column(nullable=True)
    
    # Relationships
    meal_plans = relationship("MealPlan", back_populates="user", cascade="all, delete-orphan")
    favorite_recipes = relationship("Recipe", secondary="user_favorite_recipes")
    
    def __repr__(self) -> str:
        return f"User(id={self.id}, email={self.email}, full_name={self.full_name})"
