import React from 'react';
import { ModeToggle } from '@/components/ModeToggle';
import { Badge } from '@/components/ui/badge';

export function Header() {
  return (
    <header className="container h-32 px-5 m-auto overflow-hidden sm:px-12 md:px-20 max-w-screen-xl">
      <nav
        className="flex items-center justify-center h-full mt-auto text-sm space-x-6 md:justify-start"
        aria-label="Main Navigation"
      >
        <a aria-label="Website logo, go back to homepage.">
          <a
            href="https://ui.shadcn.com"
            rel="noopener noreferrer nofollow"
            target="_blank"
          >
            <Badge variant="outline">shadcn/ui</Badge>
          </a>
        </a>
        <div className="items-center flex-grow sm:flex space-x-6"></div>
        <ModeToggle />
      </nav>
    </header>
  );
}
