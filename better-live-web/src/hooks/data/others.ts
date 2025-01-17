import { Game, getGames, getLeaderboard } from '@/api/other';
import { QUERY_PATHS } from '@/lib/constants';
import { QueryOptions, useQuery } from '@tanstack/react-query';

export const useGames = () => {
  return useQuery<any, any, Game[]>({
    queryKey: [QUERY_PATHS.GAMES],
    queryFn: () => getGames(),
  });
};

export const useLeaderboard = () => {
  return useQuery<
    any,
    any,
    {
      name: string;
      total_winnings: number;
      id: string;
    }[]
  >({
    queryKey: [QUERY_PATHS.LEADERBOARD],
    queryFn: () => getLeaderboard(),
  });
};
