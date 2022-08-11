#!/bin/sh
set -e

name="nginx-s6"
channels=`ls versions`

for channel in ${channels[*]}; do
    echo "=> ${name}/${channel}..."

    versions=`ls versions/${channel}`
    for version in ${versions[*]}; do
        echo "-  Building ${name}/${channel}/${version}"
        echo
        docker build --rm \
            -f "versions/${channel}/${version}/Dockerfile" \
            -t ${name}:${version} \
            "versions/${channel}/${version}"
        echo
    done

    echo
done
