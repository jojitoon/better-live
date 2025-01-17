import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import Redis from 'ioredis';
import { channel } from 'diagnostics_channel';

export const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

const REDIS_URL = process.env.REDIS_URL || 'redis://localhost:6379/1';
const pubClient = new Redis(REDIS_URL);
const subClient = new Redis(REDIS_URL);

const PORT = process.env.PORT || 3001;

// Subscribe to channels
subClient.subscribe('leaderboard', (err) => {
  if (err) {
    console.error('Failed to subscribe: %s', err.message);
  } else {
    console.log('Subscribed successfully to leaderboard channel');
  }
});

subClient.subscribe('events', (err) => {
  if (err) {
    console.error('Failed to subscribe: %s', err.message);
  } else {
    console.log('Subscribed successfully to events channel');
  }
});

subClient.subscribe('games', (err) => {
  if (err) {
    console.error('Failed to subscribe: %s', err.message);
  } else {
    console.log('Subscribed successfully to games channel');
  }
});

// Listen for messages
subClient.on('message', (channel, message) => {
  try {
    const data = JSON.parse(message);

    console.log('Message received:', channel);

    io.emit(channel, data);
  } catch (error) {
    console.error('Error processing message:', error);
  }
});

app.get('/', (req, res) => {
  res.send('Better Live API is running!');
});

io.on('connection', (socket) => {
  // console.log('A user connected');

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Graceful shutdown
const cleanup = () => {
  pubClient.quit();
  subClient.quit();
  io.close();
  process.exit(0);
};

process.on('SIGTERM', cleanup);
process.on('SIGINT', cleanup);

httpServer.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
