#!/bin/sh
set -e

S6_OVERLAY_RELEASE_URL=https://github.com/just-containers/s6-overlay/releases/download
S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION:-v3.1.1.2}
TARGETARCH=$1

case "${TARGETARCH}" in
    arm64) ARCH=arm ;;
    386) ARCH=x86_64 ;;
    amd64) ARCH=x86_64 ;;
    *) ARCH=$TARGETARCH ;;
esac

echo TARGETPLATFORM=${TARGETPLATFORM}
echo BUILDPLATFORM=${BUILDPLATFORM}
echo TARGETOS=${TARGETOS}
echo TARGETARCH=${TARGETARCH}
echo TARGETVARIANT=${TARGETVARIANT}

# Install xz-utils
if [ "$(command -v apt-get)" ]; then
    apt-get update -y
    apt-get install -y xz-utils
    apt-get autoremove --yes
    rm -rf /var/lib/apt/lists/*
fi

echo "Downloading ${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz"
curl -fsSL ${S6_OVERLAY_RELEASE_URL}/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz
curl -fsSL ${S6_OVERLAY_RELEASE_URL}/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256 -o /tmp/s6-overlay-noarch.tar.xz.sha256

echo "Downloading ${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz"
curl -fsSL ${S6_OVERLAY_RELEASE_URL}/${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz -o /tmp/s6-overlay-${ARCH}.tar.xz
curl -fsSL ${S6_OVERLAY_RELEASE_URL}/${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz.sha256 -o /tmp/s6-overlay-${ARCH}.tar.xz.sha256

echo "Verifying..."
cd /tmp && sha256sum -c s6-overlay-*.tar.xz.sha256

echo "Installing..."
tar -C / -Jxpf /tmp/s6-overlay-${ARCH}.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz

echo "Cleaning up..."
rm /tmp/s6-overlay-noarch.tar.xz
rm /tmp/s6-overlay-${ARCH}.tar.xz
