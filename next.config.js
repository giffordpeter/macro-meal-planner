/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['avatars.githubusercontent.com'], // For GitHub avatar images
    unoptimized: process.env.NODE_ENV === 'development',
  },
  // Enable source maps in production for better error tracking
  productionBrowserSourceMaps: true,
  // Optimize for AWS Amplify hosting
  output: 'standalone',
  poweredByHeader: false,
}

module.exports = nextConfig
