// import { useSocket } from '@/hooks/useSocket';
import { useToast } from '@/hooks/use-toast';
import { constructEventMessage } from '@/lib/utils';
import React, { useEffect } from 'react';
import { io, Socket } from 'socket.io-client';

const IOContext = React.createContext<{
  socket: any;
  liveLeaderboard: any;
  liveGames: any;
}>({
  socket: null,
  liveLeaderboard: null,
  liveGames: null,
});

export function useIO() {
  return React.useContext(IOContext);
}

export function IoProvider({ children }: { children: React.ReactNode }) {
  const socket = React.useRef<Socket | undefined>();
  const { toast } = useToast();
  const [liveLeaderboard, setLiveLeaderboard] = React.useState<any>(null);
  const [liveGames, setLiveGames] = React.useState<any>(null);

  useEffect(() => {
    if (socket.current) {
      return;
    }
    console.log('setup');
    socket.current = io(import.meta.env.VITE_LIVE_API_URL);

    socket.current.on('games', (games) => {
      console.log({ games });
      setLiveGames(games);
    });
    socket.current.on('leaderboard', (leaderboard) => {
      console.log({ leaderboard });
      setLiveLeaderboard(leaderboard);
    });
    socket.current.on('events', (event) => {
      console.log({ event });
      toast({
        title: event.event_type?.replace('-', ' ')?.toUpperCase(),
        description: constructEventMessage(
          event.event_type,
          event.minute,
          event.player,
          event.team
        ),
      });
    });
  }, []);

  return (
    <IOContext.Provider
      value={{ socket: socket.current, liveLeaderboard, liveGames }}
    >
      {children}
    </IOContext.Provider>
  );
}
