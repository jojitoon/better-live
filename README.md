# BETTER LIVE

A better way to live bet on games

# Setup

# Build docker image

```bash
docker compose build
```

# Run docker image

```bash
docker compose up
```

# NOTE

- This is a work in progress
- If the docker does not work, try running the three applications separately

## Rails api

```bash
bundle install

rails db:create
rails db:migrate

rails server
```

## Live api

```bash
npm install
npm run dev
```

## Web

```bash
npm install
npm run dev
```
