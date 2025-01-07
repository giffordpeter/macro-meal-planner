import type { Secret, SecretRotationConfig } from './types';
import { AzureKeyVaultManager } from './azure-key-vault';
import { getConfig } from '../config';

export class SecretRotationService {
  private keyVaultManager: AzureKeyVaultManager;
  private config: SecretRotationConfig;

  constructor(keyVaultManager: AzureKeyVaultManager, config: SecretRotationConfig) {
    this.keyVaultManager = keyVaultManager;
    this.config = config;
  }

  async checkAndRotateSecrets(): Promise<void> {
    if (!this.config.enabled) {
      return;
    }

    const secrets = await this.keyVaultManager.listSecrets();
    const now = new Date();

    for (const secretName of secrets) {
      const secret = await this.keyVaultManager.getSecret(secretName);
      if (!secret || !secret.expiresOn) {
        continue;
      }

      const daysUntilExpiry = this.getDaysUntilExpiry(secret.expiresOn);
      
      if (daysUntilExpiry <= this.config.notifyDaysBeforeExpiry) {
        await this.notifySecretExpiration(secret, daysUntilExpiry);
      }

      if (daysUntilExpiry <= 0) {
        await this.rotateSecret(secret);
      }
    }
  }

  private getDaysUntilExpiry(expiryDate: Date): number {
    const now = new Date();
    const diffTime = expiryDate.getTime() - now.getTime();
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }

  private async notifySecretExpiration(
    secret: Secret,
    daysRemaining: number
  ): Promise<void> {
    // TODO: Implement notification system (e.g., email, Slack, etc.)
    console.warn(
      `Secret ${secret.name} will expire in ${daysRemaining} days.`
    );
  }

  private async rotateSecret(secret: Secret): Promise<void> {
    try {
      const newSecret = await this.generateNewSecretValue(secret);
      await this.keyVaultManager.rotateSecret(secret.name, async () => newSecret);
      console.log(`Successfully rotated secret: ${secret.name}`);
    } catch (error) {
      console.error(`Failed to rotate secret ${secret.name}:`, error);
      throw error;
    }
  }

  private async generateNewSecretValue(secret: Secret): Promise<string> {
    // TODO: Implement custom secret generation logic based on secret type
    return this.generateSecureRandomString(32);
  }

  private generateSecureRandomString(length: number): string {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?';
    const array = new Uint8Array(length);
    crypto.getRandomValues(array);
    let result = '';
    for (let i = 0; i < length; i++) {
      result += charset[array[i] % charset.length];
    }
    return result;
  }
}
