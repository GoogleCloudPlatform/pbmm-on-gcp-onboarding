#!/bin/bash
# https://github.com/obrienlabs/refarch
# Michael O'Brien

# variables
CONTAINER_IMAGE=terraform-example-foundation-ado
#PORT_IN=8080
#PORT_OUT=8888
RELEASE_ID=0.0.1
DOCKER_FILE=Dockerfile
DOCKERHUB_ORG=obrienlabs

# static templates
BUILD_ID=10001
BUILD_DIR=builds
#mkdir ../../$BUILD_DIR
mkdir $BUILD_DIR
#TARGET_DIR=../../$BUILD_DIR/$BUILD_ID
TARGET_DIR=$BUILD_DIR/$BUILD_ID
mkdir $TARGET_DIR

#cd ../../
#mvn clean install -U -DskipTests=true
#cd src/docker
#cp ../../target/*.jar $TARGET_DIR
#cp $DOCKER_FILE $TARGET_DIR
#cp startService.sh $TARGET_DIR
#cd $TARGET_DIR
#docker build --rm=true --no-cache --build-arg build-id=$BUILD_ID -t $CONTAINER_IMAGE -f $DOCKER_FILE .
#docker tag $CONTAINER_IMAGE $CONTAINER_IMAGE:latest
#docker tag $CONTAINER_IMAGE $CONTAINER_IMAGE:$RELEASE_ID

# DockerHub only
docker build --rm=true --no-cache --build-arg build-id=$BUILD_ID -t $DOCKERHUB_ORG/$CONTAINER_IMAGE -f $DOCKER_FILE .
docker tag $DOCKERHUB_ORG/$CONTAINER_IMAGE $DOCKERHUB_ORG/$CONTAINER_IMAGE:$RELEASE_ID
docker tag $DOCKERHUB_ORG/$CONTAINER_IMAGE $DOCKERHUB_ORG/$CONTAINER_IMAGE:latest
docker push obrienlabs/$CONTAINER_IMAGE:$RELEASE_ID
docker push obrienlabs/$CONTAINER_IMAGE:latest

# locally
#docker stop $CONTAINER_IMAGE
#docker rm $CONTAINER_IMAGE
#echo "starting: $CONTAINER_IMAGE"
#docker run --name $CONTAINER_IMAGE \
#    -d -p $PORT_OUT:$PORT_IN \
#    -e os.environment.configuration.dir=/ \
#    -e os.environment.ecosystem=sbx \
#    $CONTAINER_IMAGE:$RELEASE_ID

#cd ../../src/docker

# Health check
#echo "sleep 10 sec"
#sleep 10
#echo "run a $PORT_OUT/v1/health/ endpoint to check the container"

# todo fix versioning
##curl -X GET "http://127.0.0.1:$PORT_OUT/v1/health/" -H "accept: application/json"
#curl -X GET "http://127.0.0.1:$PORT_OUT/health/" -H "accept: application/json"

# Run on ia64 platform only (not arm64)
echo "test a terraform exe run on ia64 only - not arm64"
docker run --name tef-sdo obrienlabs/terraform-example-foundation-ado --version