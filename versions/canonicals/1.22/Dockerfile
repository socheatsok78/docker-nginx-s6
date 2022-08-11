FROM --platform=$BUILDPLATFORM nginx:1.22

LABEL "org.opencontainers.image.title"="nginx-s6"
LABEL "org.opencontainers.image.description"="Nginx with s6-overlay"
LABEL "org.opencontainers.image.url"="https://github.com/socheatsok78/docker-nginx-s6"
LABEL "org.opencontainers.image.source"="https://github.com/socheatsok78/docker-nginx-s6"
LABEL "org.opencontainers.image.version"="1.22"
LABEL "org.opencontainers.image.licenses"="MIT"

LABEL version="1.22"
LABEL maintainer="Socheat Sok <socheatsok78@gmail.com>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV NGINX_VERSION=1.22
ENV S6_OVERLAY_VERSION=%%S6_OVERLAY_VERSION%%

ADD rootfs /

# Add s6-overlay
RUN /s6-overlay-installer.sh $TARGETARCH && \
    rm /s6-overlay-installer.sh

ENTRYPOINT ["/init"]
CMD ["nginx", "-g", "daemon off;"]
