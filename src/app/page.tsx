'use client';

import MacroBuilder from '@/components/MacroBuilder';

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4">
        <div className="py-8">
          <h1 className="text-3xl font-bold text-center mb-8 text-blue-600 tracking-tight">
            Macro Builder
          </h1>
          <MacroBuilder />
        </div>
      </div>
    </div>
  );
}
