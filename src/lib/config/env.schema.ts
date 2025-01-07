import { z } from 'zod';

export const envSchema = z.object({
  // App Configuration
  NODE_ENV: z.enum(['development', 'test', 'production']),
  APP_ENV: z.enum(['development', 'test', 'staging', 'production']),
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

  // Azure Services
  AZURE_OPENAI_KEY: z.string().min(1),
  AZURE_OPENAI_ENDPOINT: z.string().url(),
  AZURE_STORAGE_CONNECTION_STRING: z.string().min(1),
  AZURE_KEYVAULT_URL: z.string().url(),

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
