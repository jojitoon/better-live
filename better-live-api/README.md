# Better Live API

A Node.js server built with TypeScript and Socket.IO for real-time communication.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Development:
```bash
npm run dev
```

3. Build:
```bash
npm run build
```

4. Production:
```bash
npm start
```

## Features

- Express server with TypeScript
- Socket.IO integration for real-time communication
- Development mode with hot-reloading
- Production-ready build setup

## API Endpoints

- GET `/`: Health check endpoint

## Socket Events

- `connection`: Triggered when a client connects
- `disconnect`: Triggered when a client disconnects

More events can be added in `src/index.ts`
