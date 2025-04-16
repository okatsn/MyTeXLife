#!/bin/bash

set -e

IMAGE_NAME="okatsn/my-tex-life"
BUILD_IMAGE=true
TAGS=()

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --no-build) BUILD_IMAGE=false; shift ;;
        *) TAGS+=("$1"); shift ;;
    esac
done

# Check if any tags were provided
if [ ${#TAGS[@]} -eq 0 ]; then
  echo "Usage: $0 [--no-build] <tag1> [tag2 ...]"
  sleep 5
  exit 1
fi

# Build the image if BUILD_IMAGE is true
if [ "$BUILD_IMAGE" = true ]; then
  echo "Building Docker image with tag: $IMAGE_NAME:temp"
  # Build with the first tag provided
  docker-compose --env-file my-build.env -f .devcontainer/docker-compose.yml build --no-cache
  docker tag latexdevcontainer "$IMAGE_NAME:temp"
else
  echo "Skipping build step (--no-build specified)."
  echo "Assuming image $IMAGE_NAME:temp already exists locally..."
fi

# Tag and push all specified tags
for TAG in "${TAGS[@]}"; do
  echo "Tagging image as: $IMAGE_NAME:$TAG"
  docker tag "$IMAGE_NAME:temp" "$IMAGE_NAME:$TAG"

  echo "Pushing Docker image: $IMAGE_NAME:$TAG"
  docker push "$IMAGE_NAME:$TAG"
done

echo "Docker image processed successfully for tags: ${TAGS[*]}"
