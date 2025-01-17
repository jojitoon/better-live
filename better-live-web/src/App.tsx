import { useState } from 'react';
import './App.css';
import { Button } from '@/components/ui/button';
import { Toaster } from '@/components/ui/toaster';
import Leaderboard from './components/Leaderboard';
import { useMe } from './hooks/data/user';
import { useGames } from './hooks/data/others';
import { formatTime } from './lib/utils';
import { AuthForm } from './components/AuthForm';
import { BetOnGamesForm } from './components/BetForm';
import { GameCard } from './components/GameCard';
import { useIO } from './context/Io';
import { fundUserDummy } from './api/user';
import { useToast } from './hooks/use-toast';
import { useMutation } from '@tanstack/react-query';

function App() {
  const { data: user, refetch } = useMe();
  const { data: games } = useGames();
  const [showAuth, setShowAuth] = useState<'login' | 'register' | ''>('');
  const { liveGames } = useIO();
  const { toast } = useToast();

  const logout = () => {
    localStorage.removeItem('TOKEN');
    refetch();
    window?.location.reload();
  };

  const fundMutation = useMutation({
    mutationFn: fundUserDummy,
    onSuccess: () => {
      refetch();
      toast({
        title: 'Funded',
        description: 'Your account has been funded successfully',
      });
    },
  });

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
              Your chance to live a better life. Bet your way to financial
              freedom.
            </p>
            <div>
              {user ? (
                <div className='flex items-center gap-4 justify-center my-8'>
                  <p>Logged in as {user.username}</p>
                  <p className='text-bold'>
                    {user.balance?.toLocaleString('en-US', {
                      style: 'currency',
                      currency: 'USD',
                    })}
                  </p>
                  <Button onClick={() => fundMutation.mutate()}>
                    Sim fund $500
                  </Button>
                  <Button onClick={logout}>Logout</Button>
                </div>
              ) : null}
            </div>
          </div>

          {/* // current live games */}
          <div className='p-6 bg-card rounded-lg shadow-sm'>
            <h2 className='text-2xl font-semibold mb-4'>Current Live Games</h2>
          </div>

          <div className='p-6 bg-card rounded-lg shadow-sm grid gap-4 grid-cols-3'>
            {(liveGames || games)?.map((game: any) => (
              <GameCard
                key={game.id}
                homeTeam={game.home_team}
                awayTeam={game.away_team}
                homeScore={game.home_score}
                awayScore={game.away_score}
                time={formatTime(game.time_elapsed)}
              />
            ))}
          </div>

          {/* // bet on games */}
          <div className='p-6 bg-card rounded-lg shadow-sm'>
            <h2 className='text-2xl font-semibold mb-4'>Bet on Games</h2>
          </div>

          {user ? (
            <BetOnGamesForm />
          ) : (
            <div className='p-6 bg-card rounded-lg shadow-sm'>
              <h2 className='text-xl  mb-4'>
                You need to be logged in to bet on games
              </h2>
              {showAuth === '' && (
                <div className='flex gap-4 justify-center'>
                  <Button onClick={() => setShowAuth('login')}>Login</Button>
                  <Button
                    onClick={() => setShowAuth('register')}
                    className=' bg-primary-foreground text-primary hover:bg-primary hover:text-primary-foreground'
                  >
                    Register
                  </Button>
                </div>
              )}

              {showAuth !== '' && (
                <AuthForm setShowAuth={setShowAuth} showAuth={showAuth} />
              )}
            </div>
          )}

          <Leaderboard />
        </div>
      </div>
      <Toaster />
    </div>
  );
}

export default App;
