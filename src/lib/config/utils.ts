import { z } from 'zod';

export class ConfigError extends Error {
  constructor(message: string, public errors?: z.ZodError) {
    super(message);
    this.name = 'ConfigError';
  }
}

export function validateEnv<T extends z.ZodSchema>(
  schema: T,
  env: NodeJS.ProcessEnv = process.env
): z.infer<T> {
  try {
    return schema.parse(env);
  } catch (error) {
    if (error instanceof z.ZodError) {
      const formattedErrors = error.errors
        .map((err) => `${err.path.join('.')}: ${err.message}`)
        .join('\n');
      throw new ConfigError(
        `Environment validation failed:\n${formattedErrors}`,
        error
      );
    }
    throw error;
  }
}

export function isProduction(): boolean {
  return process.env.NODE_ENV === 'production';
}

export function isDevelopment(): boolean {
  return process.env.NODE_ENV === 'development';
}

export function isTest(): boolean {
  return process.env.NODE_ENV === 'test';
}

export function isStaging(): boolean {
  return process.env.APP_ENV === 'staging';
}
