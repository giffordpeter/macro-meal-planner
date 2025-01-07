import { PrismaClient } from '@prisma/client';
import { describe, test, expect, beforeAll, afterAll } from '@jest/globals';

const prisma = new PrismaClient();

describe('Database Setup Tests', () => {
  beforeAll(async () => {
    // Clean up database before tests
    await prisma.macroHistory.deleteMany();
    await prisma.planMeal.deleteMany();
    await prisma.mealIngredient.deleteMany();
    await prisma.mealCategory.deleteMany();
    await prisma.mealTag.deleteMany();
    await prisma.favoriteMeal.deleteMany();
    await prisma.meal.deleteMany();
    await prisma.plan.deleteMany();
    await prisma.profile.deleteMany();
    await prisma.user.deleteMany();
    await prisma.ingredient.deleteMany();
    await prisma.category.deleteMany();
    await prisma.tag.deleteMany();
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  test('Database connection works', async () => {
    const result = await prisma.$queryRaw<Array<{ result: number }>>`SELECT 1+1 as result`;
    expect(Array.isArray(result)).toBe(true);
    expect(result[0]).toHaveProperty('result', 2);
  });

  test('Can create and query User', async () => {
    const user = await prisma.user.create({
      data: {
        email: 'test@test.com',
        name: 'Test User',
        b2cId: 'test-b2c-id'
      }
    });

    expect(user).toHaveProperty('id');
    expect(user.email).toBe('test@test.com');

    const foundUser = await prisma.user.findUnique({
      where: { email: 'test@test.com' }
    });

    expect(foundUser).not.toBeNull();
    expect(foundUser?.name).toBe('Test User');
  });

  test('Can create and query Meal with relationships', async () => {
    // Create test user
    const user = await prisma.user.create({
      data: {
        email: 'meal-test@test.com',
        name: 'Meal Test User',
        b2cId: 'meal-test-b2c-id'
      }
    });

    // Create ingredient
    const ingredient = await prisma.ingredient.create({
      data: {
        name: 'Test Ingredient',
        calories: 100,
        protein: 10,
        carbs: 10,
        fat: 10,
        unit: 'g'
      }
    });

    // Create category
    const category = await prisma.category.create({
      data: {
        name: 'Test Category',
        description: 'Test Description'
      }
    });

    // Create tag
    const tag = await prisma.tag.create({
      data: {
        name: 'Test Tag',
        description: 'Test Description'
      }
    });

    // Create meal with relationships
    const meal = await prisma.meal.create({
      data: {
        name: 'Test Meal',
        description: 'Test Description',
        instructions: 'Test Instructions',
        prepTime: 10,
        cookTime: 20,
        servings: 4,
        servingSize: '100g',
        difficulty: 'Easy',
        calories: 400,
        protein: 30,
        carbs: 40,
        fat: 20,
        userId: user.id,
        ingredients: {
          create: {
            ingredient: {
              connect: { id: ingredient.id }
            },
            amount: 100,
            unit: 'g'
          }
        },
        categories: {
          create: {
            category: {
              connect: { id: category.id }
            }
          }
        },
        tags: {
          create: {
            tag: {
              connect: { id: tag.id }
            }
          }
        }
      },
      include: {
        ingredients: {
          include: {
            ingredient: true
          }
        },
        categories: {
          include: {
            category: true
          }
        },
        tags: {
          include: {
            tag: true
          }
        }
      }
    });

    expect(meal).toHaveProperty('id');
    expect(meal.ingredients).toHaveLength(1);
    expect(meal.categories).toHaveLength(1);
    expect(meal.tags).toHaveLength(1);
    expect(meal.ingredients[0].ingredient.name).toBe('Test Ingredient');
    expect(meal.categories[0].category.name).toBe('Test Category');
    expect(meal.tags[0].tag.name).toBe('Test Tag');
  });

  test('Cascade deletion works', async () => {
    // Create test user
    const user = await prisma.user.create({
      data: {
        email: 'cascade-test@test.com',
        name: 'Cascade Test User',
        b2cId: 'cascade-test-b2c-id',
        profiles: {
          create: {
            name: 'Test Profile',
            calories: 2000,
            protein: 150,
            carbs: 200,
            fat: 67
          }
        }
      },
      include: {
        profiles: true
      }
    });

    expect(user.profiles).toHaveLength(1);

    // Delete user
    await prisma.user.delete({
      where: { id: user.id }
    });

    // Check if profile was cascade deleted
    const profile = await prisma.profile.findFirst({
      where: { userId: user.id }
    });

    expect(profile).toBeNull();
  });
});
