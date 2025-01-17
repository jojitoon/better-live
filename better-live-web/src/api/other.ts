import { QUERY_PATHS } from '@/lib/constants';
import { ApiCaller } from './init';

export interface Game {
  id: string;
  away_team: string;
  away_score: number;
  home_team: string;
  home_score: number;
  time_elapsed: number;
  odds: {
    home: number;
    draw: number;
    away: number;
    exact_score: {
      home_1: number;
      away_1: number;
      home_2: number;
      away_2: number;
      home_3: number;
      away_3: number;
      home_4: number;
      away_4: number;
      home_5: number;
      away_5: number;
    };
    under: {
      1_5: number;
      2_5: number;
      3_5: number;
      4_5: number;
      5_5: number;
    };
    over: {
      1_5: number;
      2_5: number;
      3_5: number;
      4_5: number;
      5_5: number;
    };
  };
}

export async function getGames(): Promise<Game> {
  const { data } = await ApiCaller.get(QUERY_PATHS.GAMES);

  return (data || []) as Game;
}

export async function betOnGame(body: {
  gameId: string;
  amount: number;
  betType: string;
  pick: string;
  odds: number;
}) {
  console.log({ body });

  const { data } = await ApiCaller.post(QUERY_PATHS.BETS, {
    game_id: body.gameId,
    amount: body.amount,
    bet_type: body.betType,
    pick: body.pick,
    odds: body.odds,
  });

  return data;
}

export async function getLeaderboard() {
  const { data } = await ApiCaller.get(QUERY_PATHS.LEADERBOARD);
  return data;
}
