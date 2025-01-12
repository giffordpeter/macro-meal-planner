import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET() {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'unknown',
    database: 'not_checked'
  };

  // Only check database if not in build environment
  if (process.env.NODE_ENV !== 'build') {
    try {
      await prisma.$queryRaw`SELECT 1`;
      health.database = 'connected';
    } catch (error) {
      console.error('Database health check failed:', error);
      health.database = 'disconnected';
      health.status = 'degraded';
      if (error instanceof Error) {
        health['error'] = error.message;
      }
    } finally {
      await prisma.$disconnect();
    }
  }

  return NextResponse.json(health);
}
