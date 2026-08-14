#!/bin/bash
set -euo pipefail

FULL_NAME="$DOCKERHUB_USERNAME/$IMAGE:latest"

echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

echo "Building $FULL_NAME from $CONTEXT..."
docker built -t "$FULL_NAME" "$CONTEXT"

echo "Pushing $FULL_NAME ..."
docker push "$FULL_NAME"