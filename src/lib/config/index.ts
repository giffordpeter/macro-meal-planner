import { envSchema, type EnvSchema } from './env.schema';
import { validateEnv } from './utils';

let envConfig: EnvSchema;

export function getConfig(): EnvSchema {
  if (!envConfig) {
    envConfig = validateEnv(envSchema);
  }
  return envConfig;
}

export function getDatabaseConfig() {
  const config = getConfig();
  return {
    url: config.DATABASE_URL,
    connectionLimit: config.DATABASE_CONNECTION_LIMIT,
    sslEnabled: config.DATABASE_SSL_ENABLED,
  };
}

export function getAuthConfig() {
  const config = getConfig();
  return {
    nextAuthSecret: config.NEXTAUTH_SECRET,
    nextAuthUrl: config.NEXTAUTH_URL,
    githubId: config.AUTH_GITHUB_ID,
    githubSecret: config.AUTH_GITHUB_SECRET,
  };
}

export function getAzureConfig() {
  const config = getConfig();
  return {
    openAiKey: config.AZURE_OPENAI_KEY,
    openAiEndpoint: config.AZURE_OPENAI_ENDPOINT,
    storageConnectionString: config.AZURE_STORAGE_CONNECTION_STRING,
    keyVaultUrl: config.AZURE_KEYVAULT_URL,
  };
}

export function getMonitoringConfig() {
  const config = getConfig();
  return {
    applicationInsightsConnectionString: config.APPLICATION_INSIGHTS_CONNECTION_STRING,
    logLevel: config.LOG_LEVEL,
  };
}

export function getFeatureFlags() {
  const config = getConfig();
  return {
    aiFeatures: config.ENABLE_AI_FEATURES,
    premiumFeatures: config.ENABLE_PREMIUM_FEATURES,
  };
}

export function getCacheConfig() {
  const config = getConfig();
  return {
    redisUrl: config.REDIS_URL,
    ttl: config.CACHE_TTL,
  };
}

export function getPerformanceConfig() {
  const config = getConfig();
  return {
    edgeConfig: config.EDGE_CONFIG,
    cdnEnabled: config.CDN_ENABLED,
  };
}

export * from './env.schema';
export * from './utils';
