import type { Secret, SecretRotationConfig } from './types';
import { AWSSecretsManager } from './aws-secrets-manager';

export class SecretRotationService {
  private secretsManager: AWSSecretsManager;
  private config: SecretRotationConfig;
  private rotationInterval: NodeJS.Timeout | null = null;

  constructor(secretsManager: AWSSecretsManager, config: SecretRotationConfig) {
    this.secretsManager = secretsManager;
    this.config = config;
  }

  startRotationSchedule(): void {
    if (this.rotationInterval) {
      clearInterval(this.rotationInterval);
    }

    // Check secrets daily
    this.rotationInterval = setInterval(() => {
      this.checkAndRotateSecrets().catch(console.error);
    }, 24 * 60 * 60 * 1000);

    // Run initial check
    this.checkAndRotateSecrets().catch(console.error);
  }

  stopRotationSchedule(): void {
    if (this.rotationInterval) {
      clearInterval(this.rotationInterval);
      this.rotationInterval = null;
    }
  }

  async checkAndRotateSecrets(): Promise<void> {
    if (!this.config.enabled) {
      return;
    }

    const secrets = await this.secretsManager.listSecrets();

    for (const secret of secrets) {
      if (!secret.expiresOn) {
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
      `Secret ${secret.name} will expire in ${daysRemaining} days. Please rotate it soon.`
    );
  }

  private async rotateSecret(secret: Secret): Promise<void> {
    try {
      // Generate new secret value (implement your rotation logic here)
      const newValue = await this.generateNewSecretValue(secret);
      
      // Update the secret in AWS Secrets Manager
      await this.secretsManager.setSecret(secret.name, newValue);
      
      console.log(`Successfully rotated secret: ${secret.name}`);
    } catch (error) {
      console.error(`Failed to rotate secret ${secret.name}:`, error);
      throw error;
    }
  }

  private async generateNewSecretValue(secret: Secret): Promise<string> {
    // Implement your secret generation logic here
    // This is a placeholder implementation
    return `${secret.value}_${Date.now()}`;
  }
}
