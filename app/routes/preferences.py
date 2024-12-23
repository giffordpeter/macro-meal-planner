from flask import Blueprint, jsonify, request, current_app
from app import db
from app.models import MacroTarget, DietaryPreference

bp = Blueprint('preferences', __name__, url_prefix='/api/preferences')

@bp.route('/macro-targets', methods=['POST'])
def set_macro_targets():
    try:
        macro_target = MacroTarget.from_dict(request.json)
        db.session.add(macro_target)
        db.session.commit()
        return jsonify(macro_target.to_dict()), 201
    except Exception as e:
        current_app.logger.error(f"Error setting macro targets: {str(e)}")
        db.session.rollback()
        return jsonify({"error": "Failed to set macro targets"}), 500

@bp.route('/dietary', methods=['POST'])
def set_dietary_preferences():
    try:
        dietary_prefs = DietaryPreference.from_dict(request.json)
        db.session.add(dietary_prefs)
        db.session.commit()
        return jsonify(dietary_prefs.to_dict()), 201
    except Exception as e:
        current_app.logger.error(f"Error setting dietary preferences: {str(e)}")
        db.session.rollback()
        return jsonify({"error": "Failed to set dietary preferences"}), 500

@bp.route('/macro-targets/latest', methods=['GET'])
def get_latest_macro_targets():
    try:
        macro_target = MacroTarget.query.order_by(MacroTarget.date_created.desc()).first()
        if not macro_target:
            return jsonify({"error": "No macro targets found"}), 404
        return jsonify(macro_target.to_dict())
    except Exception as e:
        current_app.logger.error(f"Error fetching macro targets: {str(e)}")
        return jsonify({"error": "Failed to fetch macro targets"}), 500

@bp.route('/dietary/latest', methods=['GET'])
def get_latest_dietary_preferences():
    try:
        dietary_prefs = DietaryPreference.query.order_by(DietaryPreference.date_created.desc()).first()
        if not dietary_prefs:
            return jsonify({"error": "No dietary preferences found"}), 404
        return jsonify(dietary_prefs.to_dict())
    except Exception as e:
        current_app.logger.error(f"Error fetching dietary preferences: {str(e)}")
        return jsonify({"error": "Failed to fetch dietary preferences"}), 500
