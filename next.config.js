/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['avatars.githubusercontent.com'], // For GitHub avatar images
  },
  // Enable source maps in production for better error tracking
  productionBrowserSourceMaps: true,
}

module.exports = nextConfig
