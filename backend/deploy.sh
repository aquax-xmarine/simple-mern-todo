#!/bin/bash
set -euo pipefail

USERNAME="dearbleuberry"
IMAGE_BACKEND="mern-todo-backend"
TAG="v1"
FULL_NAME="$USERNAME/$IMAGE_BACKEND:$TAG"
CONTAINER="backend"
DATABASE_CONTAINER="mongo"
NETWORK="mern-todo-network"

KEY="../key-pair-2.pem"
EC2_HOST="ec2-user@100.59.91.35"

echo "Deploying $FULL_NAME to $EC2_HOST...."


ssh -o StrictHostKeyChecking=accept-new -i "$KEY" "$EC2_HOST" "
    docker pull $FULL_NAME

    docker network create $NETWORK 2>/dev/null || true

    docker stop $DATABASE_CONTAINER 2>/dev/null || true
    docker rm $DATABASE_CONTAINER 2>/dev/null || true

    docker run -d --name $DATABASE_CONTAINER \
        --network $NETWORK\
        --restart always -p 27017:27017 mongo:latest


    docker stop $CONTAINER 2>/dev/null || true
    docker rm $CONTAINER 2>/dev/null || true


    docker  run -d --name $CONTAINER \
        --network $NETWORK \
        --restart always -p 5000:5000 $FULL_NAME
"

echo "Deployed. App is live on port 5000."