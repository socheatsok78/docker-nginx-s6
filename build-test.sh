#!/bin/bash
set -e
channels=(canonicals)

DOCKER_IMAGE_BUILDER=nginx-s6
DOCKER_IMAGE_NAME=socheatsok78/nginx-s6
BUILDX_PLATFORM=linux/amd64

function create_buildx_builder() {
    echo "==> Creating Docker Buildx Builder"

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
}

function buildx_build() {
    echo "Building multi-arch docker image"

    for channel in ${channels[*]}; do
        local versions=`ls versions/${channel}`

        for version in ${versions[*]}; do
            local context="versions/$channel/$version"

            echo "==> Building ${DOCKER_IMAGE_NAME}:${version}"
            echo "[+] [context] $context"

            docker buildx build \
                --platform=${BUILDX_PLATFORM} \
                --tag ${DOCKER_IMAGE_NAME}:${version} \
                --file "$context/Dockerfile" \
                --load \
                "$context"
            echo "==> [Done] Successfully built ${DOCKER_IMAGE_NAME}:${version}"
            echo
        done
    done
}

function remove_buildx_builder() {
    echo "==> Removing Docker Buildx Builder"
    docker buildx rm ${DOCKER_IMAGE_BUILDER}-builder
}

trap "remove_buildx_builder" INT ERR

function main() {
    create_buildx_builder
    buildx_build
    remove_buildx_builder
}
main
