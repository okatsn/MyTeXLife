#!/bin/sh

echo "Dockerfile modified. Building and pushing Docker image..."

# Make sure my-build.env is identical as that in my-workspace
docker-compose --env-file my-build.env -f .devcontainer/docker-compose.yml build --no-cache

# Take the enviroment variable in okatsn/my-workspace/my-build.env
docker tag latexdevcontainer okatsn/my-tex-life:latest

docker push okatsn/my-tex-life:latest

echo "Docker image built and pushed successfully."

cd ..
