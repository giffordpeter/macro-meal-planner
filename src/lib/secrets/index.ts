import { getAWSConfig } from '../config';
import { AWSSecretsManager } from './aws-secrets-manager';
import { SecretRotationService } from './rotation-service';
import type { SecretManagerConfig, SecretRotationConfig } from './types';

let secretsManager: AWSSecretsManager | null = null;
let rotationService: SecretRotationService | null = null;

export function initializeSecretManager(
  config?: Partial<SecretManagerConfig>
): AWSSecretsManager {
  if (!secretsManager) {
    const awsConfig = getAWSConfig();
    const defaultConfig: SecretManagerConfig = {
      region: awsConfig.region,
      credentials: awsConfig.credentials,
      rotationConfig: {
        enabled: true,
        intervalDays: 90,
        notifyDaysBeforeExpiry: 14,
      },
    };

    const finalConfig = { ...defaultConfig, ...config };
    secretsManager = new AWSSecretsManager(finalConfig);

    if (finalConfig.rotationConfig) {
      rotationService = new SecretRotationService(
        secretsManager,
        finalConfig.rotationConfig
      );
    }
  }

  return secretsManager;
}

export function getSecretManager(): AWSSecretsManager {
  if (!secretsManager) {
    throw new Error('Secret manager not initialized. Call initializeSecretManager first.');
  }
  return secretsManager;
}

export function getRotationService(): SecretRotationService {
  if (!rotationService) {
    throw new Error('Rotation service not initialized. Call initializeSecretManager first.');
  }
  return rotationService;
}

// Schedule secret rotation checks
export function scheduleSecretRotation(): void {
  const manager = getSecretManager();
  const rotation = getRotationService();
  
  if (rotation) {
    rotation.startRotationSchedule();
  }
}

export * from './types';
export { AWSSecretsManager } from './aws-secrets-manager';
