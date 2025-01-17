import request from 'supertest';
import { createServer } from 'http';
import { Server } from 'socket.io';
import Redis from 'ioredis';
import { app } from '../src/index'; // Adjust the import according to your structure
import { afterAll, beforeAll, describe, expect, it, test } from '@jest/globals';

describe('Server', () => {
  let server: any;
  let io: any;

  beforeAll((done) => {
    server = createServer(app);
    io = new Server(server);
    server.listen(9999, () => {
      console.log('Server is running on port 9999');
      done();
    });
  });

  afterAll((done) => {
    io.close();
    server.close(done);
    done();
  });

  test('should respond to a GET request', (done) => {
    request(server)
      .get('/')
      .then((response) => {
        expect(response.status).toBe(200);
        done();
      });
  });

  it('should establish a socket connection', (done) => {
    const socket = require('socket.io-client')('http://localhost:3001');
    socket.on('connect', () => {
      expect(socket.connected).toBe(true);
      socket.disconnect();
      done();
    });
  });

  it('should connect to Redis', (done) => {
    const redis = new Redis();
    redis.ping().then((result) => {
      expect(result).toBe('PONG');
      redis.disconnect();
      done();
    });
  });
});
