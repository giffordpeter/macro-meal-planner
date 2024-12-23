import os
from datetime import timedelta

class Config:
    # Basic Flask config
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev'
    
    # Database
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'sqlite:///meal_planner.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # API Keys
    ANTHROPIC_API_KEY = os.environ.get('ANTHROPIC_API_KEY')
    
    # Application config
    MAX_MEALS_PER_DAY = 6
    DEFAULT_MEAL_TIMES = {
        "Breakfast": "07:30",
        "Snack 1": "10:30",
        "Lunch": "13:00",
        "Snack 2": "16:00",
        "Dinner": "19:00"
    }
    DEFAULT_MACRO_SPLITS = {
        "Breakfast": 0.25,
        "Snack 1": 0.10,
        "Lunch": 0.30,
        "Snack 2": 0.10,
        "Dinner": 0.25
    }
    DEFAULT_MACROS = {
        "protein": 180,
        "fats": 65,
        "carbs": 200
    }
