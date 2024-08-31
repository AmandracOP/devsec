#!/bin/bash

# Variables
DOCKER_REGISTRY="your-docker-registry-url"
PROJECT_NAME="application-firewall"
TAG="latest"

# Build Docker images
echo "Building Docker images..."
docker build -t ${PROJECT_NAME}_web_console:${TAG} -f docker/Dockerfile.web_console .
docker build -t ${PROJECT_NAME}_windows_agent:${TAG} -f docker/Dockerfile.windows_agent .
docker build -t ${PROJECT_NAME}_linux_agent:${TAG} -f docker/Dockerfile.linux_agent .

# Optionally push images to Docker registry
echo "Pushing Docker images to registry..."
docker tag ${PROJECT_NAME}_web_console:${TAG} ${DOCKER_REGISTRY}/${PROJECT_NAME}_web_console:${TAG}
docker tag ${PROJECT_NAME}_windows_agent:${TAG} ${DOCKER_REGISTRY}/${PROJECT_NAME}_windows_agent:${TAG}
docker tag ${PROJECT_NAME}_linux_agent:${TAG} ${DOCKER_REGISTRY}/${PROJECT_NAME}_linux_agent:${TAG}

docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}_web_console:${TAG}
docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}_windows_agent:${TAG}
docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}_linux_agent:${TAG}

# Deploy containers using Docker Compose
echo "Deploying Docker containers..."
docker-compose -f docker/docker-compose.yml up -d

# Verify the deployment
echo "Verifying the deployment..."
docker-compose -f docker/docker-compose.yml ps

# Cleanup old Docker images
echo "Cleaning up old Docker images..."
docker system prune -f

echo "Deployment completed successfully."
