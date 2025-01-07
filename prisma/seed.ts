import { PrismaClient } from '@prisma/client';
import { hash } from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed...');

  // Create basic categories
  const categories = [
    { name: 'Breakfast', description: 'Morning meals' },
    { name: 'Lunch', description: 'Midday meals' },
    { name: 'Dinner', description: 'Evening meals' },
    { name: 'Snack', description: 'Light meals and snacks' },
  ];

  for (const category of categories) {
    await prisma.category.upsert({
      where: { name: category.name },
      update: {},
      create: category,
    });
  }

  // Create basic tags
  const tags = [
    { name: 'Vegetarian', description: 'No meat' },
    { name: 'Vegan', description: 'No animal products' },
    { name: 'Gluten-Free', description: 'No gluten' },
    { name: 'Low-Carb', description: 'Reduced carbohydrates' },
    { name: 'High-Protein', description: 'Rich in protein' },
  ];

  for (const tag of tags) {
    await prisma.tag.upsert({
      where: { name: tag.name },
      update: {},
      create: tag,
    });
  }

  // Create basic ingredients
  const ingredients = [
    {
      name: 'Chicken Breast',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      unit: 'g',
    },
    {
      name: 'Brown Rice',
      calories: 111,
      protein: 2.6,
      carbs: 23,
      fat: 0.9,
      unit: 'g',
    },
    {
      name: 'Broccoli',
      calories: 55,
      protein: 3.7,
      carbs: 11.2,
      fat: 0.6,
      unit: 'g',
    },
  ];

  for (const ingredient of ingredients) {
    await prisma.ingredient.upsert({
      where: { name: ingredient.name },
      update: {},
      create: ingredient,
    });
  }

  // Create test user
  const testUser = await prisma.user.upsert({
    where: { email: 'test@example.com' },
    update: {},
    create: {
      email: 'test@example.com',
      name: 'Test User',
      b2cId: 'test-b2c-id',
      profiles: {
        create: {
          name: 'Default Profile',
          calories: 2000,
          protein: 150,
          carbs: 200,
          fat: 67,
          dietaryNeeds: 'None',
          activityLevel: 'Moderate',
          weightGoal: 'maintain',
        },
      },
    },
  });

  // Create sample meal
  const chickenBreast = await prisma.ingredient.findUnique({
    where: { name: 'Chicken Breast' },
  });
  const rice = await prisma.ingredient.findUnique({
    where: { name: 'Brown Rice' },
  });
  const broccoli = await prisma.ingredient.findUnique({
    where: { name: 'Broccoli' },
  });

  if (chickenBreast && rice && broccoli) {
    const meal = await prisma.meal.create({
      data: {
        name: 'Chicken and Rice Bowl',
        description: 'A healthy and balanced meal',
        instructions: '1. Cook rice\n2. Grill chicken\n3. Steam broccoli\n4. Combine and serve',
        prepTime: 10,
        cookTime: 20,
        servings: 1,
        servingSize: '400g',
        difficulty: 'Easy',
        calories: 500,
        protein: 40,
        carbs: 45,
        fat: 15,
        userId: testUser.id,
        ingredients: {
          create: [
            {
              ingredient: { connect: { id: chickenBreast.id } },
              amount: 150,
              unit: 'g',
            },
            {
              ingredient: { connect: { id: rice.id } },
              amount: 100,
              unit: 'g',
            },
            {
              ingredient: { connect: { id: broccoli.id } },
              amount: 150,
              unit: 'g',
            },
          ],
        },
      },
    });

    // Create a meal plan for the test user
    await prisma.plan.create({
      data: {
        name: 'Sample Meal Plan',
        startDate: new Date(),
        endDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
        userId: testUser.id,
        planMeals: {
          create: [
            {
              mealId: meal.id,
              date: new Date(),
              mealTime: 'lunch',
              servings: 1,
            },
          ],
        },
      },
    });
  }

  console.log('Seed completed successfully!');
}

main()
  .catch((e) => {
    console.error('Error during seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
