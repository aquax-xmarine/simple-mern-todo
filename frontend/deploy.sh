#!/bin/bash
set -euo pipefail

USERNAME="dearbleuberry"
IMAGE_FRONTEND="mern-todo-frontend"
TAG="v1"
FULL_NAME="$USERNAME/$IMAGE_FRONTEND:$TAG"
CONTAINER="frontend"

KEY="../key-pair-2.pem"
EC2_HOST="ec2-user@100.59.91.35"

echo "Deploying $FULL_NAME to $EC2_HOST...."


ssh -o StrictHostKeyChecking=accept-new -i "$KEY" "$EC2_HOST" "
    docker pull $FULL_NAME
    docker stop $CONTAINER 2>/dev/null || true
    docker rm $CONTAINER 2>/dev/null || true
    docker  run -d --name $CONTAINER \
        --restart always -p 5173:5173 $FULL_NAME
"

echo "Deployed. App is live on port 5173."
