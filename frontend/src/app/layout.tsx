import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Rayls Anchor - Trust-Minimized Bridge',
  description: 'Polygon-inspired checkpoint bridge bringing Rayls Public Chain to Ethereum',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 min-h-screen text-white">
        {children}
      </body>
    </html>
  );
}
