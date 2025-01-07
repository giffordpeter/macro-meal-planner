import { SecretsManager } from '@aws-sdk/client-secrets-manager';
import { getAWSConfig } from '../config';
import type { Secret, SecretManagerConfig } from './types';

export class AWSSecretsManager {
  private client: SecretsManager;

  constructor(config: SecretManagerConfig) {
    const awsConfig = getAWSConfig();
    this.client = new SecretsManager({
      region: awsConfig.region,
      credentials: awsConfig.credentials,
    });
  }

  async getSecret(secretName: string): Promise<Secret> {
    try {
      const response = await this.client.getSecretValue({ SecretId: secretName });
      
      if (!response.SecretString) {
        throw new Error(`Secret ${secretName} not found or empty`);
      }

      return {
        name: secretName,
        value: response.SecretString,
        version: response.VersionId,
      };
    } catch (error) {
      console.error(`Error retrieving secret ${secretName}:`, error);
      throw error;
    }
  }

  async setSecret(secretName: string, value: string): Promise<void> {
    try {
      await this.client.putSecretValue({
        SecretId: secretName,
        SecretString: value,
      });
    } catch (error) {
      console.error(`Error setting secret ${secretName}:`, error);
      throw error;
    }
  }

  async deleteSecret(secretName: string): Promise<void> {
    try {
      await this.client.deleteSecret({
        SecretId: secretName,
        ForceDeleteWithoutRecovery: true,
      });
    } catch (error) {
      console.error(`Error deleting secret ${secretName}:`, error);
      throw error;
    }
  }

  async listSecrets(): Promise<Secret[]> {
    try {
      const response = await this.client.listSecrets();
      return (response.SecretList || []).map(secret => ({
        name: secret.Name || '',
        value: '', // Value is not returned in list operation
        version: secret.VersionId,
      }));
    } catch (error) {
      console.error('Error listing secrets:', error);
      throw error;
    }
  }
}
