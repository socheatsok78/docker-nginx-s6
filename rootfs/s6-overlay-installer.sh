#!/bin/sh
set -e

TARGETARCH=$1

case "${TARGETARCH}" in
    arm64) ARCH=arm ;;
    386) ARCH=x86 ;;
    *) ARCH=$TARGETARCH ;;
esac

echo "Downloading s6-overlay-${ARCH}-installer to /tmp/s6-overlay-installer"
curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-${ARCH}-installer -o /tmp/s6-overlay-installer

echo "Installing s6-overlay"
chmod +x /tmp/s6-overlay-installer
/tmp/s6-overlay-installer /

echo "Removing /tmp/s6-overlay-installer"
rm /tmp/s6-overlay-installer
