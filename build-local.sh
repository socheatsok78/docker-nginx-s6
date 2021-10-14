#!/bin/sh
set -e

name="nginx-s6-overlay"
builds=`ls builds`

for version in ${builds[*]}; do
    echo "Building ${name}:${version}"
    docker build --rm -f "builds/$version/Dockerfile" -t ${name}:${version} .
done
