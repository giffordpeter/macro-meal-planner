export interface Secret {
  name: string;
  value: string;
  version?: string;
  expiresOn?: Date;
}

export interface SecretRotationConfig {
  enabled: boolean;
  intervalDays: number;
  notifyDaysBeforeExpiry: number;
}

export interface SecretManagerConfig {
  region?: string;
  credentials?: {
    accessKeyId: string;
    secretAccessKey: string;
  };
  rotationConfig?: SecretRotationConfig;
}
