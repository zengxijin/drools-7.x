#!/bin/bash

IMAGE_NAME="zengxijin/kie-server-7.12.final"
IMAGE_TAG="latest"

echo "Building the Docker container for $IMAGE_NAME:$IMAGE_TAG.."
docker build --rm -t $IMAGE_NAME:$IMAGE_TAG .
echo "Build done"