#!/bin/sh
set -e

builds=`ls builds`

DOCKER_IMAGE_BUILDER=nginx-s6
DOCKER_IMAGE_NAME=socheatsok78/nginx-s6
BUILDX_PLATFORM=linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6

# Render template
./render.sh

echo Building multi-arch docker image
docker buildx rm ${DOCKER_IMAGE_BUILDER}-builder || true
docker run --rm \
    --privileged tonistiigi/binfmt:latest \
    --install all
docker buildx create \
    --name ${DOCKER_IMAGE_BUILDER}-builder \
    --driver docker-container \
    --buildkitd-flags '--allow-insecure-entitlement security.insecure --allow-insecure-entitlement network.host' \
    --use
docker buildx inspect --bootstrap
for version in ${builds[*]}; do
    docker buildx build \
        --platform=${BUILDX_PLATFORM} \
        --tag ${DOCKER_IMAGE_NAME}:${version} \
        --push \
        --file "builds/$version/Dockerfile" .
done
docker buildx rm ${DOCKER_IMAGE_BUILDER}-builder
