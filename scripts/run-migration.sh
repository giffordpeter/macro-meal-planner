#!/bin/bash
export DATABASE_URL="postgresql://macro_user:local_dev_password@localhost:5432/macro_meal_planner_dev"
npx prisma migrate dev
