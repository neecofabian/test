import React from 'react';

import ReactSVG from '@/assets/react.svg';
import { CountButton } from '@/components/CountButton';
import { ThemeProvider } from '@/components/ThemeProvider';

import { Badge } from '@/components/ui/badge';
import { Page } from '@/components/Page';

export function App() {
  return (
    <main className="flex flex-col items-center justify-center h-screen">
      <ThemeProvider defaultTheme="dark" storageKey="vite-ui-theme">
        <Page>
          <div className="flex flex-col items-center gap-y-4">
            <div className="inline-flex items-center gap-x-4">
              <img src={ReactSVG} alt="React Logo" className="w-32" />
              <span className="text-6xl">+</span>
              <img src="/vite.svg" alt="Vite Logo" className="w-32" />
            </div>
            <CountButton />
          </div>
        </Page>
      </ThemeProvider>
    </main>
  );
}
