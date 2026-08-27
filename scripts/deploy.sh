#!/bin/bash
set -euo pipefail

FULL_NAME="$DOCKERHUB_USERNAME/$IMAGE:latest"

echo "$EC2_SSH_KEY" > key.pem
chmod 400 key.pem

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
        cd ~/simple-mern-todo

        docker pull $FULL_NAME
        docker compose up -d --force-recreate
    "

rm -f key.pem

