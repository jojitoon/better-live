import { QUERY_PATHS } from '@/lib/constants';
import { ApiCaller } from './init';

export interface User {
  id: string;
  name: string;
  email: string;
  username: string;
  password: string;
  created_at: string;
  updated_at: string;
  balance: number;
  data?: {
    total_bets: number;
    total_wins: number;
    total_losses: number;
    total_money_won: number;
  };
}

export async function getMe(): Promise<User> {
  const { data } = await ApiCaller.get(QUERY_PATHS.GET_USER);

  return (data || null) as User;
}

export async function fundUserDummy() {
  const { data } = await ApiCaller.get(QUERY_PATHS.FUND_USER_DUMMY);

  return (data || null) as User;
}
