from datetime import datetime
from flask import Blueprint, jsonify, request, current_app
from app import db
from app.models import MacroTarget, MealPlan, DietaryPreference
from app.services import meal_generator

bp = Blueprint('meal_plans', __name__, url_prefix='/api/meal-plans')

@bp.route('/', methods=['POST'])
def create_meal_plan():
    try:
        data = request.json
        
        # Get or create macro targets
        macro_target = MacroTarget.from_dict(data.get('macros', {}))
        db.session.add(macro_target)
        db.session.flush()  # Get ID without committing

        # Get or create dietary preferences
        dietary_prefs = None
        if 'dietary_preferences' in data:
            dietary_prefs = DietaryPreference.from_dict(data['dietary_preferences'])
            db.session.add(dietary_prefs)
            db.session.flush()

        # Generate meal plan
        schedule = data.get('schedule', [])
        if not schedule:
            return jsonify({"error": "Schedule is required"}), 400

        generated_plan = meal_generator.generate_meal_plan(
            schedule=schedule,
            macro_targets=macro_target.to_dict(),
            dietary_preferences=dietary_prefs.to_dict() if dietary_prefs else {}
        )

        if 'error' in generated_plan:
            return jsonify(generated_plan), 500

        # Create meal plan
        meal_plan = MealPlan(
            date=datetime.now().date(),
            macro_target_id=macro_target.id,
            dietary_preference_id=dietary_prefs.id if dietary_prefs else None,
            generated_plan=generated_plan
        )
        db.session.add(meal_plan)
        db.session.commit()

        return jsonify(meal_plan.to_dict()), 201

    except Exception as e:
        current_app.logger.error(f"Error creating meal plan: {str(e)}")
        db.session.rollback()
        return jsonify({"error": "Failed to create meal plan"}), 500

@bp.route('/', methods=['GET'])
def get_meal_plans():
    try:
        meal_plans = MealPlan.query.order_by(MealPlan.date_created.desc()).limit(10)
        return jsonify([plan.to_dict() for plan in meal_plans])
    except Exception as e:
        current_app.logger.error(f"Error fetching meal plans: {str(e)}")
        return jsonify({"error": "Failed to fetch meal plans"}), 500

@bp.route('/<int:id>', methods=['GET'])
def get_meal_plan(id):
    try:
        meal_plan = MealPlan.query.get_or_404(id)
        return jsonify(meal_plan.to_dict())
    except Exception as e:
        current_app.logger.error(f"Error fetching meal plan {id}: {str(e)}")
        return jsonify({"error": "Failed to fetch meal plan"}), 500
