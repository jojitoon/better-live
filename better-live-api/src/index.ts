import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import Redis from 'ioredis';

const app = express();
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

const PORT = process.env.PORT || 3000;

// Subscribe to channels
subClient.subscribe('leaderboard', (err) => {
  if (err) {
    console.error('Failed to subscribe: %s', err.message);
  } else {
    console.log('Subscribed successfully to leaderboard channel');
  }
});

// Listen for messages
subClient.on('message', (channel, message) => {
  try {
    const data = JSON.parse(message);
    console.log(`Received message from ${channel}:`, data);

    // Emit the message to all connected clients
    // You can customize this based on the message type or target room
    if (data.room) {
      io.to(data.room).emit(data.event || 'message', data.payload);
    } else {
      io.emit(data.event || 'message', data.payload);
    }
  } catch (error) {
    console.error('Error processing message:', error);
  }
});

app.get('/', (req, res) => {
  res.send('Better Live API is running!');
});

io.on('connection', (socket) => {
  console.log('A user connected');

  // Handle joining rooms
  socket.on('join', (room) => {
    socket.join(room);
    console.log(`Socket ${socket.id} joined room ${room}`);
  });

  // Handle leaving rooms
  socket.on('leave', (room) => {
    socket.leave(room);
    console.log(`Socket ${socket.id} left room ${room}`);
  });

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
