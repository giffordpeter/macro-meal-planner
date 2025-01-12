from fastapi import APIRouter

from app.api.v1.endpoints import auth, users, recipes, meal_plans, ingredients

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
api_router.include_router(recipes.router, prefix="/recipes", tags=["Recipes"])
api_router.include_router(meal_plans.router, prefix="/meal-plans", tags=["Meal Plans"])
api_router.include_router(ingredients.router, prefix="/ingredients", tags=["Ingredients"])
