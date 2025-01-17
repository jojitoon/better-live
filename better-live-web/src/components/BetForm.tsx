import { useGames } from '@/hooks/data/others';
import { useMe } from '@/hooks/data/user';
import { useToast } from '@/hooks/use-toast';
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select';
import { useMemo, useState } from 'react';
import { Button } from './ui/button';
import { Input } from './ui/input';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from './ui/table';
import { ToggleGroup, ToggleGroupItem } from './ui/toggle-group';
import { Bold, Italic, Underline } from 'lucide-react';
import { useMutation } from '@tanstack/react-query';
import { betOnGame } from '@/api/other';

export const BetOnGamesForm = () => {
  const { toast } = useToast();
  const { data: user } = useMe();
  const { data: games, refetch } = useGames();
  const [data, setData] = useState<{
    gameId: string | null;
    betType: string | null;
    amount: number | null;
    pick: string | null;
    odds: number | null;
  }>({
    gameId: null,
    betType: null,
    amount: null,
    pick: null,
    odds: null,
  });

  const mutations = useMutation({
    mutationFn: betOnGame,
    onSuccess: () => {
      toast({
        title: 'Bet placed',
        description: 'Your bet has been placed successfully',
      });
      setData({
        gameId: null,
        betType: null,
        amount: null,
        pick: null,
        odds: null,
      });
    },
    onError: (error: any) => {
      const message = error?.response?.data?.error;

      toast({
        title: message || 'Bet failed',
        description: 'Your bet placement has failed',
      });
    },
  });

  const handlePlaceBet = () => {
    const pick = data.pick?.split('-') as string[];
    const body = {
      ...data,
      pick: pick?.length > 1 ? pick[1] : data.pick,
    };

    mutations.mutate(body as any);
  };

  const handleRefresh = () => {
    refetch();
    toast({
      title: 'Refreshed',
      description: 'Your data has been refreshed successfully',
    });
  };

  const selectedGame = useMemo(() => {
    return games?.find((game) => game.id === data.gameId);
  }, [data.gameId, games]);

  return (
    <div className='p-6 bg-card rounded-lg shadow-sm'>
      <p className='text-xl mb-4'>
        Total Games bet: {user?.data?.total_bets || 0}
        {' - \t'} Total Games won: {user?.data?.total_wins || 0}
        {' - \t'} Total Money won: {user?.data?.total_money_won || '$0'}
      </p>

      <div className='flex items-center mb-4 gap-4 justify-between'>
        <Select onValueChange={(value) => setData({ ...data, gameId: value })}>
          <SelectTrigger>
            <SelectValue placeholder='Select Game' />
          </SelectTrigger>
          <SelectContent>
            {games?.map((game) => (
              <SelectItem key={game.id} value={game.id}>
                {game.home_team} vs {game.away_team}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        {/* <Select onValueChange={(value) => setData({ ...data, betType: value })}>
            <SelectTrigger>
              <SelectValue placeholder='Select Bet Type' />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value='winner'>Winner</SelectItem>
              <SelectItem value='exact'>Exact Score</SelectItem>
              <SelectItem value='over'>Over</SelectItem>
              <SelectItem value='under'>Under</SelectItem>
            </SelectContent>
          </Select>
  
          <Select onValueChange={(value) => setData({ ...data, pick: value })}>
            <SelectTrigger>
              <SelectValue placeholder='Select Pick' />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value='home'>Home</SelectItem>
              <SelectItem value='away'>Away</SelectItem>
              <SelectItem value='draw'>Draw</SelectItem>
            </SelectContent>
          </Select>
  
          <Select
            onValueChange={(value) => setData({ ...data, odds: Number(value) })}
          >
            <SelectTrigger>
              <SelectValue placeholder='Select Odds' />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value='1.5'>1.5</SelectItem>
              <SelectItem value='2.5'>2.5</SelectItem>
              <SelectItem value='3.5'>3.5</SelectItem>
            </SelectContent>
          </Select> */}

        <Input
          placeholder='Amount'
          type='number'
          value={data.amount || ''}
          onChange={(e) =>
            setData({ ...data, amount: parseInt(e.target.value) })
          }
        />
      </div>
      {selectedGame && (
        <div>
          <div className='flex items-center bg-gray-200 text-gray-600 p-2'>
            <div className='w-[150px] text-left'>Type</div>
            <div className='text-left'>Options</div>
          </div>
          <div className='flex items-center p-2 py-5'>
            <div className='w-[150px] text-left'>Winner</div>
            <div className='text-left'>
              <div className='flex-inline items-center gap-2'>
                <ToggleGroup
                  type='single'
                  variant='outline'
                  value={data.pick || ''}
                  onValueChange={(value) =>
                    setData({
                      ...data,
                      pick: value,
                      odds: (selectedGame?.odds as any)?.[value] || 0,
                      betType: 'winner',
                    })
                  }
                >
                  <ToggleGroupItem
                    value='home'
                    aria-label='Toggle home'
                    className='min-w-[100px] [&[data-state=on]]:bg-gray-600 [&[data-state=on]]:text-white'
                  >
                    Home Win : {selectedGame?.odds?.home || '0.0'}
                  </ToggleGroupItem>
                  <ToggleGroupItem
                    value='draw'
                    aria-label='Toggle draw'
                    className='min-w-[100px] [&[data-state=on]]:bg-gray-600 [&[data-state=on]]:text-white'
                  >
                    Draw : {selectedGame?.odds?.draw || '0.0'}
                  </ToggleGroupItem>
                  <ToggleGroupItem
                    value='away'
                    aria-label='Toggle away'
                    className='min-w-[100px] [&[data-state=on]]:bg-gray-600 [&[data-state=on]]:text-white'
                  >
                    Away Win : {selectedGame?.odds?.away || '0.0'}
                  </ToggleGroupItem>
                </ToggleGroup>
              </div>
            </div>
          </div>
          <div className='flex  p-2 py-5 w-full max-w-2xl '>
            <div className='w-[150px] text-left'>Exact Score</div>
            <div className='text-left flex-1 '>
              <ToggleGroup
                type='single'
                variant='outline'
                value={data.pick || ''}
                className='flex-wrap justify-start'
                onValueChange={(value) => {
                  const [, , odds] = value.split('-');
                  setData({
                    ...data,
                    pick: value,
                    odds: odds ? Number(odds) : 0,
                    betType: 'exact_score',
                  });
                }}
              >
                {Object.entries(selectedGame?.odds.exact_score || {}).map(
                  ([key, value]) => (
                    <ToggleGroupItem
                      key={key}
                      value={`exact_score-${key}-${value}`}
                      aria-label={`Exact Score ${key}`}
                      className='min-w-[100px] [&[data-state=on]]:bg-gray-600 [&[data-state=on]]:text-white'
                    >
                      {key?.split('_')?.join(' : ')}
                    </ToggleGroupItem>
                  )
                )}
              </ToggleGroup>
            </div>
          </div>
          <div className='flex  p-2 py-5 w-full max-w-2xl '>
            <div className='w-[150px] text-left'>Over</div>
            <div className='text-left flex-1 '>
              <ToggleGroup
                type='single'
                variant='outline'
                value={data.pick || ''}
                className='flex-wrap justify-start'
                onValueChange={(value) => {
                  const [, , odds] = value.split('-');
                  setData({
                    ...data,
                    pick: value,
                    odds: odds ? Number(odds) : 0,
                    betType: 'over',
                  });
                }}
              >
                {Object.entries(selectedGame?.odds.over || {}).map(
                  ([key, value]) => (
                    <ToggleGroupItem
                      key={key}
                      value={`over-${key}-${value}`}
                      aria-label={`Over ${key}`}
                      className='min-w-[100px] [&[data-state=on]]:bg-gray-600 [&[data-state=on]]:text-white'
                    >
                      {key?.replace('_', '.')}
                    </ToggleGroupItem>
                  )
                )}
              </ToggleGroup>
            </div>
          </div>
          <div className='flex  p-2 py-5 w-full max-w-2xl '>
            <div className='w-[150px] text-left'>Under</div>
            <div className='text-left flex-1 '>
              <ToggleGroup
                type='single'
                variant='outline'
                value={data.pick || ''}
                className='flex-wrap justify-start'
                onValueChange={(value) => {
                  const [, , odds] = value.split('-');
                  setData({
                    ...data,
                    pick: value,
                    odds: odds ? Number(odds) : 0,
                    betType: 'under',
                  });
                }}
              >
                {Object.entries(selectedGame?.odds.under || {}).map(
                  ([key, value]) => (
                    <ToggleGroupItem
                      key={key}
                      value={`under-${key}-${value}`}
                      aria-label={`Under ${key}`}
                      className='min-w-[100px] [&[data-state=on]]:bg-gray-600 [&[data-state=on]]:text-white'
                    >
                      {key?.replace('_', '.')}
                    </ToggleGroupItem>
                  )
                )}
              </ToggleGroup>
            </div>
          </div>
        </div>
      )}
      <div className='flex justify-between mt-4'>
        <div className='flex gap-4'>
          <div>
            <b>Odds</b>: {(data.odds || 0).toFixed(1)}
          </div>
          <div>
            <b>Total Amount to Win: </b>
            {((data.amount || 0) * (data.odds || 0)).toLocaleString('en-US', {
              style: 'currency',
              currency: 'USD',
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            })}
          </div>
        </div>
        <div className='flex gap-4'>
          <Button
            onClick={handlePlaceBet}
            className='mr-2'
            disabled={!data.pick || !data.amount}
          >
            Place Bet
          </Button>
          <Button variant='outline' onClick={handleRefresh}>
            Refresh
          </Button>
        </div>
      </div>
    </div>
  );
};
