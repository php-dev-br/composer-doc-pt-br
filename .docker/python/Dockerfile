### dev ###

FROM python:3.9.15-alpine3.16 AS python
LABEL maintainer="Adiel Cristo <adiel@adielcristo.com>"

# Install dependencies and tools
RUN apk update && \
    apk add --no-cache --virtual .build-deps \
        gcc=11.2.1_git20220219-r2 \
        musl-dev=1.2.3-r0 && \
    apk add --virtual .tool-deps \
        git=2.36.3-r0 && \
    pip install \
        pip==22.3 \
        mkdocs==1.4.1 && \
    apk del --purge .build-deps

WORKDIR "/var/www"
