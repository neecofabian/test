import React from 'react';
import { Routes, Route, Outlet, Link, BrowserRouter } from 'react-router-dom';

import ReactSVG from '@/assets/react.svg';
import { CountButton } from '@/components/CountButton';
import { ThemeProvider } from '@/components/ThemeProvider';

import { Page } from '@/components/Page';
import { Create } from '@/pages/Create';

export function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Gallery />}>
          <Route path="create" element={<Create />} />
          <Route path="*" element={<NoMatch />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

// TODO: make root / a Layout component for shared nav bar

function Gallery() {
  return (
    <main className="flex flex-col items-center justify-center h-screen">
      <ThemeProvider defaultTheme="dark" storageKey="vite-ui-theme">
        <Page>
          <div className="flex flex-col items-center gap-y-4">
            <div className="inline-flex items-center gap-x-4">
              <img src={ReactSVG} alt="React Logo" className="w-32" />
            </div>
            <CountButton />
          </div>
        </Page>
      </ThemeProvider>
      <Outlet /> {/* Renders child routes */}
    </main>
  );
}

function NoMatch() {
  return (
    <div>
      <h2>Nothing to see here!</h2>
      <p>
        <Link to="/">Go to the gallery</Link>
      </p>
    </div>
  );
}
