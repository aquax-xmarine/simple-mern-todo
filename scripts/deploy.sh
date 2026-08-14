#!/bin/bash
set -euo pipefail

FULL_NAME="$DOCKERHUB_USERNAME/$IMAGE:latest"

echo "$EC2_SSH_KEY" > key.pem
chmod 400 key.pem

ssh -o StrictHostKeyChecking=accept-new -i key.pem "$EC2_USER@$EC2_HOST" "
    docker pull $FULL_NAME

    docker stop $CONTAINER 2>/dev/null || true
    docker rm $CONTAINER 2>/dev/null || true

    docker run -d --name $CONTAINER \
        --restart always -p $PORT:$PORT $FULL_NAME

    "

rm -f key.pem

