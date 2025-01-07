interface Ingredient {
  name: string;
  protein: number;
  carbs: number;
  fat: number;
}

interface Meal {
  name: string;
  ingredients: Ingredient[];
  macros?: Macros;
}

interface Macros {
  protein: number;
  carbs: number;
  fat: number;
}

interface MacroRange {
  min: number;
  max: number;
}

interface TargetMacros {
  protein: MacroRange;
  carbs: MacroRange;
  fat: MacroRange;
}

interface MealPlan {
  meals: Meal[];
}

interface ValidationResult {
  isValid: boolean;
  totalMacros: Macros;
  errors?: string[];
}

export function calculateMacros(meal: Meal): Macros {
  const initialMacros: Macros = { protein: 0, carbs: 0, fat: 0 };
  
  return meal.ingredients.reduce((acc, ingredient) => {
    return {
      protein: acc.protein + ingredient.protein,
      carbs: acc.carbs + ingredient.carbs,
      fat: acc.fat + ingredient.fat
    };
  }, initialMacros);
}

export function validateMealPlan(mealPlan: MealPlan, targetMacros: TargetMacros): ValidationResult {
  const totalMacros = mealPlan.meals.reduce((acc, meal) => {
    const mealMacros = meal.macros || { protein: 0, carbs: 0, fat: 0 };
    return {
      protein: acc.protein + mealMacros.protein,
      carbs: acc.carbs + mealMacros.carbs,
      fat: acc.fat + mealMacros.fat
    };
  }, { protein: 0, carbs: 0, fat: 0 });

  const errors: string[] = [];

  if (totalMacros.protein < targetMacros.protein.min) {
    errors.push('Protein below minimum target');
  }
  if (totalMacros.protein > targetMacros.protein.max) {
    errors.push('Protein exceeds maximum target');
  }

  if (totalMacros.carbs < targetMacros.carbs.min) {
    errors.push('Carbs below minimum target');
  }
  if (totalMacros.carbs > targetMacros.carbs.max) {
    errors.push('Carbs exceeds maximum target');
  }

  if (totalMacros.fat < targetMacros.fat.min) {
    errors.push('Fat below minimum target');
  }
  if (totalMacros.fat > targetMacros.fat.max) {
    errors.push('Fat exceeds maximum target');
  }

  return {
    isValid: errors.length === 0,
    totalMacros,
    errors: errors.length > 0 ? errors : undefined
  };
}

export function calculateDailyCalories(macros: Macros): number {
  // 1g protein = 4 calories
  // 1g carbs = 4 calories
  // 1g fat = 9 calories
  return (macros.protein * 4) + (macros.carbs * 4) + (macros.fat * 9);
}
