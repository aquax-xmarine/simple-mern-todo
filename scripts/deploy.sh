#!/bin/bash

set -euo pipefail

FULL_NAME="$DOCKERHUB_USERNAME/$IMAGE:latest"

echo "$EC2_SSH_KEY" > key.pem
chmod 400 key.pem
trap 'rm -f key.pem' EXIT

echo "Copying Docker Compose files to EC2..."

ssh -o StrictHostKeyChecking=accept-new \
    -i key.pem \
    "$EC2_USER@$EC2_HOST" \
    "mkdir -p ~/simple-mern-todo"

scp -o StrictHostKeyChecking=accept-new \
    -i key.pem \
    docker-compose.yml \
    nginx.conf \
    "$EC2_USER@$EC2_HOST:~/simple-mern-todo/"

echo "Deploying to EC2..."

ssh -o StrictHostKeyChecking=accept-new \
    -i key.pem \
    "$EC2_USER@$EC2_HOST" "

        set -e

        cd ~/simple-mern-todo

        echo 'Docker Compose version:'
        docker compose version

        echo 'Creating .env file...'
        cat > .env <<EOF
DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME
IMAGE=$IMAGE
MONGO_URI=$MONGO_URI
EOF

        echo 'Pulling latest Docker image...'
        docker pull $FULL_NAME

        echo 'Starting containers...'
        docker compose up -d --force-recreate

        echo 'Container status:'
        docker compose ps

        echo 'Deployment completed successfully!'
    "