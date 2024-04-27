#!/bin/bash
# https://github.com/obrienlabs/refarch
# Michael O'Brien

CONTAINER_IMAGE=terraform-example-foundation-ado
RELEASE_ID=0.0.1
DOCKER_FILE=Dockerfile
DOCKERHUB_ORG=obrienlabs
CONTAINER_NAME=tef-ado

# DockerHub only
docker rm -v $CONTAINER_NAME
docker build --rm=true --no-cache --build-arg build-id=$BUILD_ID -t $DOCKERHUB_ORG/$CONTAINER_IMAGE -f $DOCKER_FILE .
docker tag $DOCKERHUB_ORG/$CONTAINER_IMAGE $DOCKERHUB_ORG/$CONTAINER_IMAGE:$RELEASE_ID
docker tag $DOCKERHUB_ORG/$CONTAINER_IMAGE $DOCKERHUB_ORG/$CONTAINER_IMAGE:latest
docker push $DOCKERHUB_ORG/$CONTAINER_IMAGE:$RELEASE_ID
docker push $DOCKERHUB_ORG/$CONTAINER_IMAGE:latest

# Run on ia64 platform only (not arm64)
echo "test a terraform exe run on ia64 only - not arm64 - should print at least 1.3.10"
docker run --name $CONTAINER_NAME $DOCKERHUB_ORG/$CONTAINER_IMAGE --version