import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeRegistry } from '@/components/ThemeRegistry';
import { SessionProvider } from "next-auth/react";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Macro Meal Planner",
  description: "AI-powered meal planning based on your macro goals",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <ThemeRegistry>
          <SessionProvider>
            {children}
          </SessionProvider>
        </ThemeRegistry>
      </body>
    </html>
  );
}
