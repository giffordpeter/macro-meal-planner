import { getConfig } from '../config';
import { AzureKeyVaultManager } from './azure-key-vault';
import { SecretRotationService } from './rotation-service';
import type { SecretManagerConfig, SecretRotationConfig } from './types';

let keyVaultManager: AzureKeyVaultManager | null = null;
let rotationService: SecretRotationService | null = null;

export function initializeSecretManager(
  config?: Partial<SecretManagerConfig>
): AzureKeyVaultManager {
  if (!keyVaultManager) {
    const envConfig = getConfig();
    const defaultConfig: SecretManagerConfig = {
      keyVaultUrl: envConfig.AZURE_KEYVAULT_URL,
      rotationConfig: {
        enabled: true,
        intervalDays: 90,
        notifyDaysBeforeExpiry: 14,
      },
    };

    const finalConfig = { ...defaultConfig, ...config };
    keyVaultManager = new AzureKeyVaultManager(finalConfig);

    if (finalConfig.rotationConfig) {
      rotationService = new SecretRotationService(
        keyVaultManager,
        finalConfig.rotationConfig
      );
    }
  }

  return keyVaultManager;
}

export function getSecretManager(): AzureKeyVaultManager {
  if (!keyVaultManager) {
    throw new Error('Secret manager not initialized. Call initializeSecretManager first.');
  }
  return keyVaultManager;
}

export function getRotationService(): SecretRotationService {
  if (!rotationService) {
    throw new Error('Rotation service not initialized. Call initializeSecretManager first.');
  }
  return rotationService;
}

// Schedule secret rotation checks
export function scheduleSecretRotation(): void {
  const service = getRotationService();
  // Check secrets daily
  setInterval(() => {
    service.checkAndRotateSecrets().catch(console.error);
  }, 24 * 60 * 60 * 1000);
}

export * from './types';
export { AzureKeyVaultManager } from './azure-key-vault';
export { SecretRotationService } from './rotation-service';
