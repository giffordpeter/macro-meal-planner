const fs = require('fs');
const path = require('path');

// Required environment variables
const REQUIRED_VARS = [
  'NEXTAUTH_URL',
  'DATABASE_URL',
  'AUTH_GITHUB_ID',
  'AUTH_GITHUB_SECRET',
  'NEXTAUTH_SECRET',
  'OPENAI_API_KEY'
];

// Optional environment variables with default values
const OPTIONAL_VARS = {
  'NODE_ENV': 'production',
  'PORT': '3000',
  'DATABASE_SSL_ENABLED': 'true',
  'DATABASE_CONNECTION_LIMIT': '10',
  'AWS_REGION': 'us-east-1'
};

// Build artifacts that must exist
const REQUIRED_ARTIFACTS = [
  '.next/BUILD_ID',
  '.next/build-manifest.json',
  '.next/prerender-manifest.json',
  '.next/server/pages-manifest.json'
];

// Validate environment variables
function validateEnvironment() {
  console.log('Validating environment variables...');
  
  // Check required variables
  const missingVars = REQUIRED_VARS.filter(varName => !process.env[varName]);
  
  if (missingVars.length > 0) {
    console.error('Missing required environment variables:', missingVars);
    process.exit(1);
  }
  
  // Set default values for optional variables
  Object.entries(OPTIONAL_VARS).forEach(([varName, defaultValue]) => {
    if (!process.env[varName]) {
      console.log(`Setting default value for ${varName}: ${defaultValue}`);
      process.env[varName] = defaultValue;
    }
  });
  
  // Validate DATABASE_URL format
  const dbUrl = process.env.DATABASE_URL;
  if (!dbUrl.startsWith('postgresql://')) {
    console.error('DATABASE_URL must start with postgresql://');
    process.exit(1);
  }
  
  // Validate NEXTAUTH_URL format
  const authUrl = process.env.NEXTAUTH_URL;
  if (!authUrl.startsWith('http://') && !authUrl.startsWith('https://')) {
    console.error('NEXTAUTH_URL must start with http:// or https://');
    process.exit(1);
  }
  
  console.log('Environment validation successful');
}

// Validate build artifacts
function validateBuildArtifacts() {
  console.log('Validating build artifacts...');
  const missingArtifacts = REQUIRED_ARTIFACTS.filter(artifact => {
    const artifactPath = path.join(process.cwd(), artifact);
    return !fs.existsSync(artifactPath);
  });
  
  if (missingArtifacts.length > 0) {
    console.error('Missing required build artifacts:', missingArtifacts);
    process.exit(1);
  }
  
  console.log('Build artifacts validation successful');
}

// Main validation
try {
  validateEnvironment();
  validateBuildArtifacts();
  console.log('All validations passed successfully');
  process.exit(0);
} catch (error) {
  console.error('Validation failed:', error);
  process.exit(1);
}
