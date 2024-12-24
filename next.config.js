/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',  // Static site generation
  images: {
    unoptimized: true,
  }
}

module.exports = nextConfig
