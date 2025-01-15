import { useState } from 'react';
import './App.css';
import { Button } from '@/components/ui/button';
import { Toaster } from '@/components/ui/toaster';
import { useToast } from '@/hooks/use-toast';

function App() {
  const [count, setCount] = useState(0);
  const { toast } = useToast();

  const handleIncrement = () => {
    setCount((prev) => prev + 1);
    toast({
      title: 'Counter Updated',
      description: `Counter value is now ${count + 1}`,
    });
  };

  return (
    <div className='min-h-screen bg-background p-8'>
      <div className='container mx-auto'>
        <h1 className='text-4xl font-bold mb-8'>Better Live Web</h1>
        <div className='grid gap-4'>
          <div className='p-6 bg-card rounded-lg shadow-sm'>
            <h2 className='text-2xl font-semibold mb-4'>
              Welcome to Better Live
            </h2>
            <p className='text-muted-foreground'>
              This is a React application built with Vite and styled with
              shadcn-ui.
            </p>
          </div>

          <div className='p-6 bg-card rounded-lg shadow-sm'>
            <p className='text-xl mb-4'>Counter: {count}</p>
            <Button onClick={handleIncrement} className='mr-2'>
              Increment
            </Button>
            <Button variant='outline' onClick={() => setCount(0)}>
              Reset
            </Button>
          </div>
        </div>
      </div>
      <Toaster />
    </div>
  );
}

export default App;
