FROM --platform=$BUILDPLATFORM nginx:1.23.1

LABEL "org.opencontainers.image.title"="nginx-s6"
LABEL "org.opencontainers.image.description"="Nginx with s6-overlay"
LABEL "org.opencontainers.image.url"="https://github.com/socheatsok78/docker-nginx-s6"
LABEL "org.opencontainers.image.source"="https://github.com/socheatsok78/docker-nginx-s6"
LABEL "org.opencontainers.image.version"="1.23.1"
LABEL "org.opencontainers.image.licenses"="MIT"

LABEL version="1.23.1"
LABEL maintainer="Socheat Sok <socheatsok78@gmail.com>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV S6_NGINX_VERSION=1.23.1
ENV S6_OVERLAY_VERSION=v3.1.1.2

ADD rootfs /

# Add s6-overlay
RUN /s6-overlay-installer.sh $TARGETARCH && \
    rm /s6-overlay-installer.sh

ENTRYPOINT ["/init"]
CMD ["nginx", "-g", "daemon off;"]
