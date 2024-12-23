from datetime import datetime
from app import db

class MacroTarget(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    protein = db.Column(db.Integer, nullable=False)
    carbs = db.Column(db.Integer, nullable=False)
    fats = db.Column(db.Integer, nullable=False)
    date_created = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'protein': self.protein,
            'carbs': self.carbs,
            'fats': self.fats,
            'calories': self.calculate_calories()
        }

    def calculate_calories(self):
        return (self.protein * 4) + (self.carbs * 4) + (self.fats * 9)

    @staticmethod
    def from_dict(data):
        return MacroTarget(
            protein=data.get('protein'),
            carbs=data.get('carbs'),
            fats=data.get('fats')
        )
