class UI {
    static exportToPDF() {
        const element = document.getElementById('pdf-meal-plan');
        const opt = {
            margin: 1,
            filename: 'meal-plan.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { scale: 2 },
            jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
        };

        html2pdf().set(opt).from(element).save();
    }

    static printMealPlan() {
        window.print();
    }

    static showToast(message, type = 'info') {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.textContent = message;
        
        document.body.appendChild(toast);
        
        // Trigger reflow
        toast.offsetHeight;
        
        // Add visible class
        toast.classList.add('visible');
        
        // Remove after animation
        setTimeout(() => {
            toast.classList.remove('visible');
            setTimeout(() => {
                document.body.removeChild(toast);
            }, 300);
        }, 3000);
    }
}
