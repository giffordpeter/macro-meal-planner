from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from config import Config

db = SQLAlchemy()
migrate = Migrate()

def create_app(config_class=Config):
    app = Flask(__name__, 
                static_folder='../static',
                template_folder='../templates')
    app.config.from_object(config_class)

    db.init_app(app)
    migrate.init_app(app, db)

    from app.routes import meal_plans, preferences
    app.register_blueprint(meal_plans.bp)
    app.register_blueprint(preferences.bp)

    @app.route('/')
    def index():
        return render_template('index.html')

    return app
