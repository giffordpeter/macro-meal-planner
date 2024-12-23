from datetime import datetime
from app import db

class MealPlan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, nullable=False)
    macro_target_id = db.Column(db.Integer, db.ForeignKey('macro_target.id'), nullable=False)
    dietary_preference_id = db.Column(db.Integer, db.ForeignKey('dietary_preference.id'))
    generated_plan = db.Column(db.JSON, nullable=False)
    date_created = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    macro_target = db.relationship('MacroTarget', backref='meal_plans')
    dietary_preference = db.relationship('DietaryPreference', backref='meal_plans')

    def to_dict(self):
        return {
            'id': self.id,
            'date': self.date.isoformat(),
            'macro_target': self.macro_target.to_dict(),
            'dietary_preference': self.dietary_preference.to_dict() if self.dietary_preference else None,
            'generated_plan': self.generated_plan,
            'date_created': self.date_created.isoformat()
        }

    @staticmethod
    def from_dict(data, macro_target_id, dietary_preference_id=None):
        return MealPlan(
            date=datetime.strptime(data.get('date'), '%Y-%m-%d').date(),
            macro_target_id=macro_target_id,
            dietary_preference_id=dietary_preference_id,
            generated_plan=data.get('generated_plan')
        )
