class MealPlanner {
    constructor() {
        this.nutritionCalc = new NutritionCalculator();
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Macro input listeners
        ['protein', 'carbs', 'fats'].forEach(macro => {
            document.getElementById(macro).addEventListener('input', () => {
                this.nutritionCalc.updateMacroDisplays();
            });
        });

        // Calories slider listener
        document.getElementById('calories-slider').addEventListener('input', (e) => {
            const targetCalories = parseInt(e.target.value);
            const newMacros = this.nutritionCalc.calculateMacroSplit(targetCalories);
            
            document.getElementById('protein').value = newMacros.protein;
            document.getElementById('carbs').value = newMacros.carbs;
            document.getElementById('fats').value = newMacros.fats;
            
            this.nutritionCalc.updateMacroDisplays();
        });

        // Dietary preference listeners
        document.getElementById('vegan').addEventListener('change', (e) => {
            if (e.target.checked) {
                document.getElementById('vegetarian').checked = true;
            }
        });

        document.getElementById('vegetarian').addEventListener('change', (e) => {
            if (!e.target.checked) {
                document.getElementById('vegan').checked = false;
            }
        });
    }

    async generatePlan() {
        try {
            this.showLoading();
            
            const macroTargets = {
                protein: parseInt(document.getElementById('protein').value),
                carbs: parseInt(document.getElementById('carbs').value),
                fats: parseInt(document.getElementById('fats').value)
            };

            const dietaryPreferences = {
                vegetarian: document.getElementById('vegetarian').checked,
                vegan: document.getElementById('vegan').checked,
                gluten_free: document.getElementById('gluten-free').checked,
                dairy_free: document.getElementById('dairy-free').checked,
                keto: document.getElementById('keto').checked,
                paleo: document.getElementById('paleo').checked,
                custom_restrictions: document.getElementById('custom-restrictions').value
                    .split(',')
                    .map(item => item.trim())
                    .filter(item => item)
            };

            const schedule = Array.from(document.querySelectorAll('.meal-time')).map(meal => ({
                name: meal.querySelector('input[readonly]').value,
                time: meal.querySelector('input[type="time"]').value
            }));

            const response = await fetch('/api/meal-plans/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    macros: macroTargets,
                    dietary_preferences: dietaryPreferences,
                    schedule: schedule
                })
            });

            if (!response.ok) {
                throw new Error('Failed to generate meal plan');
            }

            const data = await response.json();
            this.displayMealPlan(data);
            this.showExportButtons();

        } catch (error) {
            console.error('Error:', error);
            this.showError('Failed to generate meal plan. Please try again.');
        } finally {
            this.hideLoading();
        }
    }

    displayMealPlan(data) {
        const outputDiv = document.getElementById('meal-plan-output');
        const pdfDiv = document.getElementById('pdf-meal-plan');
        const plan = data.generated_plan.plan;

        // Create HTML for both display and PDF versions
        const displayHtml = this.createMealPlanHtml(plan);
        const pdfHtml = this.createMealPlanHtml(plan, true);

        outputDiv.innerHTML = displayHtml;
        pdfDiv.querySelector('.meals-container').innerHTML = pdfHtml;
        
        // Update macro summary in PDF version
        const macroSummary = `
            <h2>Daily Macro Targets</h2>
            <p>Protein: ${data.macro_target.protein}g</p>
            <p>Carbs: ${data.macro_target.carbs}g</p>
            <p>Fats: ${data.macro_target.fats}g</p>
            <p>Total Calories: ${data.macro_target.calories}</p>
        `;
        pdfDiv.querySelector('.macro-summary').innerHTML = macroSummary;
    }

    createMealPlanHtml(plan, forPdf = false) {
        return plan.map(meal => `
            <div class="meal-card">
                <h3>${meal.name} - ${meal.time}</h3>
                <div class="meal-ingredients">
                    <h4>Ingredients:</h4>
                    <ul>
                        ${meal.ingredients.map(ing => `<li>${ing}</li>`).join('')}
                    </ul>
                </div>
                <div class="meal-instructions">
                    <h4>Instructions:</h4>
                    <ol>
                        ${meal.instructions.map(inst => `<li>${inst}</li>`).join('')}
                    </ol>
                </div>
                <div class="macro-breakdown">
                    <p>Macros: 
                        Protein: ${meal.macros.protein}g | 
                        Carbs: ${meal.macros.carbs}g | 
                        Fats: ${meal.macros.fats}g
                    </p>
                </div>
            </div>
        `).join('');
    }

    showLoading() {
        document.querySelector('.loading').style.display = 'block';
    }

    hideLoading() {
        document.querySelector('.loading').style.display = 'none';
    }

    showError(message) {
        // You could implement a toast or alert system here
        alert(message);
    }

    showExportButtons() {
        document.getElementById('export-pdf').style.display = 'inline-block';
        document.getElementById('print-plan').style.display = 'inline-block';
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    window.mealPlanner = new MealPlanner();
});
