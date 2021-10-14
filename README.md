# Nginx Dockerfiles with s6-overlay

**Official repo**: https://github.com/nginxinc/docker-nginx  
**Official Docker Hub**: https://hub.docker.com/_/nginx

## Image

| Registry                                                             | Image                         |
| -------------------------------------------------------------------- | ----------------------------- |
| [Docker Hub](https://hub.docker.com/r/socheatsok78/nginx-s6-overlay) | socheatsok78/nginx-s6-overlay |

Following platforms for this image are available:

```
$ docker run --rm mplatform/mquery socheatsok78/nginx-s6-overlay
Image: socheatsok78/nginx-s6-overlay:alpine (digest: sha256:42cc4266a5d69a57dea32be8f8781d2afff2eaedb3a559ba4eb2d804aa71b257)
 * Manifest List: Yes (Image type: application/vnd.docker.distribution.manifest.list.v2+json)
 * Supported platforms:
   - linux/amd64
   - linux/arm64
   - linux/arm/v7
   - linux/arm/v6
```

### Supported tags

- `latest`
- `mainline`, `1.21`, `1.21.3
- `alpine`, `1.21-alpine`, `1.21.3-alpine`


## How to use this image

```sh
$ docker run --name some-nginx -v /some/content:/usr/share/nginx/html:ro -d socheatsok78/nginx-s6-overlay
```

Alternatively, a simple Dockerfile can be used to generate a new image that includes the necessary content (which is a much cleaner solution than the bind mount above):

```Dockerfile
FROM socheatsok78/nginx-s6-overlay
COPY static-html-directory /usr/share/nginx/html
```

Place this file in the same directory as your directory of content ("static-html-directory"), run `docker build -t some-content-nginx .`, then start your container:

```sh
$ docker run --name some-nginx -d some-content-nginx
```

## Documentations

The usage guide are the same as the official [nginx](https://hub.docker.com/_/nginx) docker image.

For s6-overlay usage guide see: https://github.com/just-containers/s6-overlay/#readme
