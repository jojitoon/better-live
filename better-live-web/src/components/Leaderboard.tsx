import React from 'react';
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { useLeaderboard } from '@/hooks/data/others';
import { useIO } from '@/context/Io';

const Leaderboard = () => {
  const { data: leaderboard } = useLeaderboard();
  const { liveLeaderboard } = useIO();

  return (
    <div>
      <h2 className='text-2xl font-bold mb-4'>Leaderboard</h2>
      <Table>
        <TableCaption>A leaderboard of most bet placed worldwide.</TableCaption>
        <TableHeader>
          <TableRow>
            <TableHead className='w-[100px] text-left'>Rank</TableHead>
            <TableHead className='text-left'>Name</TableHead>
            <TableHead className='text-left'>Amount</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {(liveLeaderboard || leaderboard)?.map((user: any, index: number) => (
            <TableRow key={user.id}>
              <TableCell className='font-medium text-left'>
                {index + 1}
              </TableCell>
              <TableCell className='font-medium text-left'>
                {user.name}
              </TableCell>
              <TableCell className='font-medium text-left'>
                {user.total_winnings?.toLocaleString('en-US', {
                  style: 'currency',
                  currency: 'USD',
                })}
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
};

export default Leaderboard;
