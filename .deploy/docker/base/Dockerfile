ARG DOCKER_IMAGE_PYTHON

FROM ${DOCKER_IMAGE_PYTHON} AS python

LABEL maintainer="Adiel Cristo <adiel@adielcristo.com>"

ARG MKDOCS_VERSION=1.0.4

# Install dependencies and tools
RUN apk add --no-cache --update --virtual .build-deps \
        git && \
    pip install --upgrade \
        pip \
        mkdocs==${MKDOCS_VERSION}

WORKDIR "/var/www"
