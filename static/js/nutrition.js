class NutritionCalculator {
    constructor() {
        this.proteinCaloriesPerGram = 4;
        this.carbsCaloriesPerGram = 4;
        this.fatsCaloriesPerGram = 9;
    }

    calculateTotalCalories(protein, carbs, fats) {
        return (protein * this.proteinCaloriesPerGram) +
               (carbs * this.carbsCaloriesPerGram) +
               (fats * this.fatsCaloriesPerGram);
    }

    calculateMacroSplit(calories) {
        const currentProtein = parseFloat(document.getElementById('protein').value) || 0;
        const currentCarbs = parseFloat(document.getElementById('carbs').value) || 0;
        const currentFats = parseFloat(document.getElementById('fats').value) || 0;
        
        const currentTotal = this.calculateTotalCalories(currentProtein, currentCarbs, currentFats);
        
        if (currentTotal === 0) return { protein: 0, carbs: 0, fats: 0 };
        
        const ratio = calories / currentTotal;
        
        return {
            protein: Math.round(currentProtein * ratio),
            carbs: Math.round(currentCarbs * ratio),
            fats: Math.round(currentFats * ratio)
        };
    }

    updateMacroDisplays() {
        const protein = parseFloat(document.getElementById('protein').value) || 0;
        const carbs = parseFloat(document.getElementById('carbs').value) || 0;
        const fats = parseFloat(document.getElementById('fats').value) || 0;

        document.getElementById('protein-display').textContent = protein;
        document.getElementById('carbs-display').textContent = carbs;
        document.getElementById('fats-display').textContent = fats;

        const proteinCals = protein * this.proteinCaloriesPerGram;
        const carbsCals = carbs * this.carbsCaloriesPerGram;
        const fatsCals = fats * this.fatsCaloriesPerGram;
        const totalCals = proteinCals + carbsCals + fatsCals;

        document.getElementById('protein-cals').textContent = proteinCals;
        document.getElementById('carbs-cals').textContent = carbsCals;
        document.getElementById('fats-cals').textContent = fatsCals;
        document.getElementById('total-calories').textContent = totalCals;
        document.getElementById('calories-slider').value = totalCals;
    }
}
