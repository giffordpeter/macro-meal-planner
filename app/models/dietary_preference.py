from datetime import datetime
from app import db

class DietaryPreference(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    vegetarian = db.Column(db.Boolean, default=False)
    vegan = db.Column(db.Boolean, default=False)
    gluten_free = db.Column(db.Boolean, default=False)
    dairy_free = db.Column(db.Boolean, default=False)
    keto = db.Column(db.Boolean, default=False)
    paleo = db.Column(db.Boolean, default=False)
    custom_restrictions = db.Column(db.String(500))
    date_created = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'vegetarian': self.vegetarian,
            'vegan': self.vegan,
            'gluten_free': self.gluten_free,
            'dairy_free': self.dairy_free,
            'keto': self.keto,
            'paleo': self.paleo,
            'custom_restrictions': self.custom_restrictions.split(',') if self.custom_restrictions else []
        }

    @staticmethod
    def from_dict(data):
        return DietaryPreference(
            vegetarian=data.get('vegetarian', False),
            vegan=data.get('vegan', False),
            gluten_free=data.get('gluten_free', False),
            dairy_free=data.get('dairy_free', False),
            keto=data.get('keto', False),
            paleo=data.get('paleo', False),
            custom_restrictions=','.join(data.get('custom_restrictions', []))
        )
