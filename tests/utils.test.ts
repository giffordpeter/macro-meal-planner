import { calculateMacros, validateMealPlan, calculateDailyCalories } from '../utils/meal-planning';

describe('Meal Planning Utils', () => {
  describe('calculateMacros', () => {
    it('should correctly calculate macros for a meal', () => {
      const meal = {
        name: 'Test Meal',
        ingredients: [
          { name: 'Chicken Breast', protein: 25, carbs: 0, fat: 3 },
          { name: 'Rice', protein: 4, carbs: 45, fat: 1 },
          { name: 'Olive Oil', protein: 0, carbs: 0, fat: 14 }
        ]
      };

      const macros = calculateMacros(meal);
      expect(macros).toEqual({
        protein: 29,
        carbs: 45,
        fat: 18
      });
    });

    it('should return zero macros for empty ingredients', () => {
      const meal = {
        name: 'Empty Meal',
        ingredients: []
      };

      const macros = calculateMacros(meal);
      expect(macros).toEqual({
        protein: 0,
        carbs: 0,
        fat: 0
      });
    });
  });

  describe('validateMealPlan', () => {
    it('should validate a meal plan within target macros', () => {
      const mealPlan = {
        meals: [
          {
            name: 'Breakfast',
            ingredients: [],
            macros: { protein: 20, carbs: 30, fat: 10 }
          },
          {
            name: 'Lunch',
            ingredients: [],
            macros: { protein: 30, carbs: 40, fat: 15 }
          }
        ]
      };

      const targetMacros = {
        protein: { min: 45, max: 55 },
        carbs: { min: 65, max: 75 },
        fat: { min: 20, max: 30 }
      };

      const result = validateMealPlan(mealPlan, targetMacros);
      expect(result.isValid).toBe(true);
      expect(result.totalMacros).toEqual({
        protein: 50,
        carbs: 70,
        fat: 25
      });
    });

    it('should invalidate a meal plan outside target macros', () => {
      const mealPlan = {
        meals: [
          {
            name: 'High Protein Meal',
            ingredients: [],
            macros: { protein: 100, carbs: 20, fat: 10 }
          }
        ]
      };

      const targetMacros = {
        protein: { min: 45, max: 55 },
        carbs: { min: 65, max: 75 },
        fat: { min: 20, max: 30 }
      };

      const result = validateMealPlan(mealPlan, targetMacros);
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Protein exceeds maximum target');
      expect(result.errors).toContain('Carbs below minimum target');
      expect(result.errors).toContain('Fat below minimum target');
    });
  });

  describe('calculateDailyCalories', () => {
    it('should correctly calculate total calories from macros', () => {
      const macros = {
        protein: 150,  // 150g * 4 = 600 calories
        carbs: 200,    // 200g * 4 = 800 calories
        fat: 60        // 60g * 9 = 540 calories
      };               // Total: 1940 calories

      const calories = calculateDailyCalories(macros);
      expect(calories).toBe(1940);
    });

    it('should return 0 calories for zero macros', () => {
      const macros = {
        protein: 0,
        carbs: 0,
        fat: 0
      };

      const calories = calculateDailyCalories(macros);
      expect(calories).toBe(0);
    });
  });
});
