# Simple MERN Todo

A deliberately small Todo app (MongoDB, Express, React, Node) built as a teaching base:
it works fine run locally, and the exercise is to containerize it yourselves.

## Project structure

```
simple-mern-todo/
├── backend/     # Express REST API (port 5000)
└── frontend/    # React app built with Vite (port 5173)
```

## API

| Method | Route            | Description       |
|--------|------------------|--------------------|
| GET    | /api/todos       | List all todos     |
| POST   | /api/todos       | Create a todo      |
| PUT    | /api/todos/:id   | Update a todo      |
| DELETE | /api/todos/:id   | Delete a todo      |
| GET    | /api/health      | Health check       |

## Prerequisites

- Node.js 18+
- A running MongoDB instance (local install, or a free MongoDB Atlas cluster)

## Running locally (no Docker)

### 1. Backend

```bash
cd backend
cp .env.example .env   # edit MONGO_URI if needed
npm install
npm run dev             # starts on http://localhost:5000
```

### 2. Frontend

In a second terminal:

```bash
cd frontend
cp .env.example .env   # edit VITE_API_URL if needed
npm install
npm run dev             # starts on http://localhost:5173
```

Open http://localhost:5173 in your browser. The frontend calls the backend at
the URL set in `frontend/.env` (`VITE_API_URL`), and the backend connects to
MongoDB using the URI set in `backend/.env` (`MONGO_URI`).

## Docker exercise 

This repo intentionally has no Dockerfiles or docker-compose.yml yet. As an exercise, write:

1. A `Dockerfile` for `backend/` (Node base image, install deps, expose port 5000, run `node server.js`).
2. A `Dockerfile` for `frontend/` (build the Vite app, then serve the static output — e.g. with `nginx` or `serve`).
3. A `docker-compose.yml` at the repo root that wires up three services: `mongo`, `backend`, `frontend`, with the correct
   environment variables and a Docker network so `backend` can reach `mongo` by service name, and `frontend` can reach
   `backend`.
4. A named volume for MongoDB data so todos persist across `docker compose down`/`up`.

A working solution should let a fresh clone run entirely via:

```bash
docker compose up --build
```
