#!/bin/bash
set -e

dirs=`ls builds`
builds=($dirs)

DOCKER_IMAGE_BUILDER=nginx-s6
DOCKER_IMAGE_NAME=socheatsok78/nginx-s6
BUILDX_PLATFORM=linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6

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
for version in "${builds[@]}"; do
    echo "==> Building ${DOCKER_IMAGE_NAME}:${version}"
    echo "[+] [context] builds/$version"
    docker buildx build \
        --platform=${BUILDX_PLATFORM} \
        --tag ${DOCKER_IMAGE_NAME}:${version} \
        --push \
        --file "builds/$version/Dockerfile" \
        "builds/$version"
    echo "==> [Done] Successfully built ${DOCKER_IMAGE_NAME}:${version}"
    echo
done
docker buildx rm ${DOCKER_IMAGE_BUILDER}-builder
