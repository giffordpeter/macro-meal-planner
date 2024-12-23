import os
import anthropic
from flask import current_app

class MealGeneratorService:
    def __init__(self):
        self.client = anthropic.Anthropic(api_key=os.getenv('ANTHROPIC_API_KEY'))

    def generate_meal_plan(self, schedule, macro_targets, dietary_preferences):
        """Generate a meal plan based on schedule, macros, and dietary preferences."""
        meal_ratios = current_app.config['DEFAULT_MACRO_SPLITS']
        meals_data = []

        for meal in schedule:
            meal_name = meal['name']
            ratio = meal_ratios.get(meal_name, 0.20)
            
            meal_macros = {
                'protein': int(macro_targets['protein'] * ratio),
                'carbs': int(macro_targets['carbs'] * ratio),
                'fats': int(macro_targets['fats'] * ratio)
            }

            try:
                meal_data = self._generate_single_meal(meal_name, meal['time'], meal_macros, dietary_preferences)
                meals_data.append(meal_data)
            except Exception as e:
                current_app.logger.error(f"Error generating meal {meal_name}: {str(e)}")
                return {"error": f"Failed to generate meal plan for {meal_name}"}

        return {"plan": meals_data}

    def _generate_single_meal(self, meal_name, meal_time, macros, dietary_preferences):
        """Generate a single meal using the Claude API."""
        prompt = self._create_meal_prompt(meal_name, meal_time, macros, dietary_preferences)

        try:
            message = self.client.messages.create(
                model="claude-3-opus-20240229",
                max_tokens=1000,
                temperature=0.7,
                system="You are a professional nutritionist and chef. Generate meal plans that strictly adhere to macro requirements and dietary preferences. Always return valid JSON.",
                messages=[{"role": "user", "content": prompt}]
            )
            
            meal_data = eval(message.content[0].text)
            meal_data['time'] = meal_time
            meal_data['name'] = meal_name
            return meal_data

        except Exception as e:
            current_app.logger.error(f"Claude API error: {str(e)}")
            raise

    def _create_meal_prompt(self, meal_name, meal_time, macros, preferences):
        """Create the prompt for the Claude API."""
        return f"""Generate a meal for {meal_name} at {meal_time} with these macros:
        - Protein: {macros['protein']}g
        - Carbs: {macros['carbs']}g
        - Fats: {macros['fats']}g

        Dietary preferences:
        - Vegetarian: {preferences['vegetarian']}
        - Vegan: {preferences['vegan']}
        - Gluten-free: {preferences['gluten_free']}
        - Dairy-free: {preferences['dairy_free']}
        - Keto: {preferences['keto']}
        - Paleo: {preferences['paleo']}
        - Foods to avoid: {preferences['custom_restrictions']}

        Please provide:
        1. A list of ingredients with quantities
        2. Simple cooking instructions
        3. Exact macro breakdown
        
        Format as JSON with these keys: ingredients (array), instructions (array), macros (object)"""
