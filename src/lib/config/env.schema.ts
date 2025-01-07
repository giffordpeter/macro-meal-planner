import { z } from 'zod';

export const envSchema = z.object({
  // App Configuration
  NODE_ENV: z.enum(['development', 'production']),
  APP_ENV: z.enum(['development', 'staging', 'production']),
  APP_URL: z.string().url(),

  // Database Configuration
  DATABASE_URL: z.string().url(),
  DATABASE_CONNECTION_LIMIT: z.coerce.number().int().positive(),
  DATABASE_SSL_ENABLED: z.coerce.boolean(),

  // Authentication Settings
  NEXTAUTH_SECRET: z.string().min(1),
  NEXTAUTH_URL: z.string().url(),
  AUTH_GITHUB_ID: z.string().min(1),
  AUTH_GITHUB_SECRET: z.string().min(1),

  // AWS Services
  OPENAI_API_KEY: z.string().min(1),
  OPENAI_API_MODEL: z.string().min(1),
  AWS_S3_BUCKET: z.string().min(1),
  AWS_REGION: z.string().min(1),
  AWS_ACCESS_KEY_ID: z.string().min(1),
  AWS_SECRET_ACCESS_KEY: z.string().min(1),

  // Monitoring
  APPLICATION_INSIGHTS_CONNECTION_STRING: z.string().min(1),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']),

  // Feature Flags
  ENABLE_AI_FEATURES: z.coerce.boolean(),
  ENABLE_PREMIUM_FEATURES: z.coerce.boolean(),

  // Cache Settings
  REDIS_URL: z.string().url(),
  CACHE_TTL: z.coerce.number().int().positive(),

  // Performance Settings
  EDGE_CONFIG: z.enum(['development', 'test', 'staging', 'production']),
  CDN_ENABLED: z.coerce.boolean(),
});

export type EnvSchema = z.infer<typeof envSchema>;
