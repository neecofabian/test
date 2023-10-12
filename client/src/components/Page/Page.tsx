// Inspired heavily by https://github.com/brianlovin/brian-lovin-next/tree/main/src/components/Page

import React from 'react';
import { Header } from '@/components/Header';

interface PageProps {
  children: React.ReactNode;
}

export function Page(props: PageProps) {
  const { children } = props;
  return (
    <>
      <Header />
      <div className="h-full px-4 py-24 md:py-32 lg:px-0">{children}</div>
    </>
  );
}
