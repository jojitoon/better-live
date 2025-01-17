import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App.tsx';
import { IoProvider } from './context/Io.tsx';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient({
  defaultOptions: {
    mutations: {
      onSuccess: () => {
        queryClient.invalidateQueries();
      },
    },
  },
});

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <IoProvider>
        <App />
      </IoProvider>
    </QueryClientProvider>
  </StrictMode>
);
