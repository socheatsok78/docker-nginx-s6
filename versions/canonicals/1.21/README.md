# About

Nginx with [s6-overlay](https://github.com/just-containers/s6-overlay).

---

## Features

- Nginx: 1.21
- S6 Overlay: v2.2.0.1
- Multi-platform image
- Use official nginx container configurations

## Image

| Registry                                                                                           | Image                                             |
| -------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| [Docker Hub](https://hub.docker.com/r/socheatsok78/nginx-s6)                                       | docker.io/socheatsok78/nginx-s6:1.21 |
| [GitHub Package Registry](https://github.com/socheatsok78/docker-nginx-s6/pkgs/container/nginx-s6) | ghcr.io/socheatsok78/nginx-s6:1.21   |

## How to use this image

```sh
$ docker run --name some-nginx -v /some/content:/usr/share/nginx/html:ro -d socheatsok78/nginx-s6:1.21
```

Alternatively, a simple Dockerfile can be used to generate a new image that includes the necessary content (which is a much cleaner solution than the bind mount above):

```Dockerfile
FROM socheatsok78/nginx-s6:1.21
COPY static-html-directory /usr/share/nginx/html
```

Place this file in the same directory as your directory of content ("static-html-directory"), run `docker build -t some-content-nginx .`, then start your container:

```sh
$ docker run --name some-nginx -d some-content-nginx
```

## Documentations

The usage guide are the same as the official [nginx](https://hub.docker.com/_/nginx) docker image.

For s6-overlay usage guide see: https://github.com/just-containers/s6-overlay/#readme

## License

Licensed under the [MIT](LICENSE).
