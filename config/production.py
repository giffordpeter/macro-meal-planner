import os
from config import Config

class ProductionConfig(Config):
    DEBUG = False
    TESTING = False
    
    # Use Azure SQL Database if configured, otherwise fallback to SQLite
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///meal_planner.db'
    
    # Security settings
    SESSION_COOKIE_SECURE = True
    REMEMBER_COOKIE_SECURE = True
    SESSION_COOKIE_HTTPONLY = True
    REMEMBER_COOKIE_HTTPONLY = True
