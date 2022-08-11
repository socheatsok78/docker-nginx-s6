FROM --platform=$BUILDPLATFORM nginx:latest

LABEL maintainer="Socheat Sok <socheatsok78@gmail.com>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ADD rootfs /

# Add s6-overlay
RUN /s6-overlay-installer.sh $TARGETARCH

ENTRYPOINT ["/init"]
CMD ["nginx", "-g", "daemon off;"]
