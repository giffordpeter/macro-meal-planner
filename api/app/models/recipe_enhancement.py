from typing import List, Optional

from sqlalchemy import ForeignKey, String, Table
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .base import Base

# Association tables
recipe_tags = Table(
    "recipe_tags",
    Base.metadata,
    mapped_column("recipe_id", ForeignKey("recipe.id"), primary_key=True),
    mapped_column("tag_id", ForeignKey("tag.id"), primary_key=True),
)

recipe_alternative_ingredients = Table(
    "recipe_alternative_ingredients",
    Base.metadata,
    mapped_column("recipe_id", ForeignKey("recipe.id"), primary_key=True),
    mapped_column("original_ingredient_id", ForeignKey("ingredient.id")),
    mapped_column("alternative_ingredient_id", ForeignKey("ingredient.id")),
    mapped_column("notes", String(255), nullable=True),
)

class Tag(Base):
    """Tags for categorizing recipes."""
    
    name: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    category: Mapped[str] = mapped_column(String(50), nullable=False)  # dietary, cuisine, meal_type, etc.
    
    # Relationships
    recipes = relationship("Recipe", secondary=recipe_tags, back_populates="tags")

class MealPrepInstruction(Base):
    """Detailed meal prep instructions for recipes."""
    
    recipe_id: Mapped[int] = mapped_column(ForeignKey("recipe.id"), nullable=False)
    step_number: Mapped[int] = mapped_column(nullable=False)
    instruction: Mapped[str] = mapped_column(String(1000), nullable=False)
    time_estimate_minutes: Mapped[Optional[int]] = mapped_column(nullable=True)
    can_prep_ahead: Mapped[bool] = mapped_column(nullable=False, default=False)
    storage_instructions: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    max_prep_ahead_hours: Mapped[Optional[int]] = mapped_column(nullable=True)
    
    # Relationships
    recipe = relationship("Recipe", back_populates="prep_instructions")
    
    __table_args__ = (
        sa.UniqueConstraint('recipe_id', 'step_number', name='uq_prep_instruction_step'),
    )

class ShoppingListItem(Base):
    """Generated shopping list items for meal plans."""
    
    meal_plan_id: Mapped[int] = mapped_column(ForeignKey("mealplan.id"), nullable=False)
    ingredient_id: Mapped[int] = mapped_column(ForeignKey("ingredient.id"), nullable=False)
    amount: Mapped[str] = mapped_column(String(50), nullable=False)
    aisle: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    purchased: Mapped[bool] = mapped_column(nullable=False, default=False)
    
    # Relationships
    meal_plan = relationship("MealPlan", back_populates="shopping_list")
    ingredient = relationship("Ingredient")
    
    __table_args__ = (
        sa.UniqueConstraint('meal_plan_id', 'ingredient_id', name='uq_shopping_list_item'),
    )
