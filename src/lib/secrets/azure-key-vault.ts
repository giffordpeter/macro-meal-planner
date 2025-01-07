import { DefaultAzureCredential } from '@azure/identity';
import { SecretClient } from '@azure/keyvault-secrets';
import { getConfig } from '../config';
import type { Secret, SecretManagerConfig } from './types';

export class AzureKeyVaultManager {
  private client: SecretClient;
  private config: SecretManagerConfig;

  constructor(config: SecretManagerConfig) {
    this.config = config;
    const credential = new DefaultAzureCredential({
      managedIdentityClientId: config.managedIdentityClientId,
    });
    this.client = new SecretClient(config.keyVaultUrl, credential);
  }

  async getSecret(secretName: string): Promise<Secret | null> {
    try {
      const secret = await this.client.getSecret(secretName);
      return {
        name: secret.name,
        value: secret.value || '',
        version: secret.properties.version,
        expiresOn: secret.properties.expiresOn,
      };
    } catch (error) {
      if (error.code === 'SecretNotFound') {
        return null;
      }
      throw error;
    }
  }

  async setSecret(
    secretName: string,
    value: string,
    expiresOn?: Date
  ): Promise<Secret> {
    const options = expiresOn ? { expiresOn } : undefined;
    const secret = await this.client.setSecret(secretName, value, options);
    return {
      name: secret.name,
      value: secret.value || '',
      version: secret.properties.version,
      expiresOn: secret.properties.expiresOn,
    };
  }

  async listSecrets(): Promise<string[]> {
    const secrets = this.client.listPropertiesOfSecrets();
    const secretNames: string[] = [];
    for await (const secret of secrets) {
      secretNames.push(secret.name);
    }
    return secretNames;
  }

  async rotateSecret(
    secretName: string,
    generateNewValue: () => Promise<string>
  ): Promise<Secret> {
    const newValue = await generateNewValue();
    return this.setSecret(secretName, newValue);
  }
}
