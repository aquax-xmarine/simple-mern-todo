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
        set -e

        echo 'Checking Docker Compose...'

        if ! docker compose version >/dev/null 2>&1; then
            echo 'Docker Compose not found. Installing...'

            sudo mkdir -p /usr/local/lib/docker/cli-plugins

            sudo curl -SL \
                https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
                -o /usr/local/lib/docker/cli-plugins/docker-compose

            sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

            echo 'Docker Compose installed:'
            docker compose version
        else
            echo 'Docker Compose already installed:'
            docker compose version
        fi

        cd ~/simple-mern-todo

        echo 'Pulling latest Docker image...'
        docker pull $FULL_NAME

        echo 'Starting containers...'
        docker compose up -d --force-recreate

        echo 'Deployment completed!'
    "

rm -f key.pem

