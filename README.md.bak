# Macro Meal Planner

A web application that generates personalized meal plans based on your macro targets and dietary preferences.

## Features

- Set custom macro targets (protein, carbs, fats)
- Specify dietary preferences (vegetarian, vegan, gluten-free, etc.)
- Customize meal schedule
- Generate meal plans with detailed recipes and instructions
- Export meal plans to PDF
- Print-friendly format

## Project Structure

```
macro-meal-planner/
├── app/
│   ├── models/          # Database models
│   ├── routes/          # API endpoints
│   ├── services/        # Business logic
│   └── utils/           # Helper functions
├── static/
│   ├── css/            # Stylesheets
│   └── js/             # JavaScript files
├── templates/
│   ├── components/     # Reusable template components
│   └── pages/          # Page templates
├── config.py           # Application configuration
├── requirements.txt    # Python dependencies
└── run.py             # Application entry point
```

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd macro-meal-planner
```

2. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set up environment variables:
Create a `.env` file in the root directory with:
```
FLASK_APP=run.py
FLASK_ENV=development
SECRET_KEY=your-secret-key
ANTHROPIC_API_KEY=your-claude-api-key
```

5. Initialize the database:
```bash
flask db upgrade
```

6. Run the application:
```bash
python run.py
```

The application will be available at `http://localhost:8086`

## Development

### Adding New Features

1. Create new models in `app/models/`
2. Add routes in `app/routes/`
3. Implement business logic in `app/services/`
4. Add frontend components in `templates/components/`

### Code Style

- Follow PEP 8 for Python code
- Use ES6+ features for JavaScript
- Maintain component-based structure for templates

## API Endpoints

- `POST /api/meal-plans/`: Generate a new meal plan
- `GET /api/meal-plans/`: List recent meal plans
- `GET /api/meal-plans/<id>`: Get specific meal plan
- `POST /api/preferences/macro-targets`: Set macro targets
- `POST /api/preferences/dietary`: Set dietary preferences

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
