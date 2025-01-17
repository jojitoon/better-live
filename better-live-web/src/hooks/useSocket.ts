import { io } from 'socket.io-client';

export const useSocket = () => {
  const socket = io(import.meta.env.VITE_LIVE_API_URL);

  socket.on('connect', () => {
    console.log('Connected to the server');
  });

  socket.on('error', (error) => {
    console.error('Socket error:', error);
  });

  socket.on('disconnect', () => {
    console.log('Disconnected from the server');
  });

  return socket;
};
