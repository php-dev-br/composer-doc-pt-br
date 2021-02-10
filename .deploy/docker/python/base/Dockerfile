ARG DOCKER_IMAGE_PYTHON

FROM ${DOCKER_IMAGE_PYTHON} AS python

LABEL maintainer="Adiel Cristo <adiel@adielcristo.com>"

# Alpine packages
ARG PACKAGE_GCC="gcc=10.2.1_pre1-r3"
ARG PACKAGE_GIT="git=2.30.1-r0"
ARG PACKAGE_MUSL_DEV="musl-dev=1.2.2-r0"

# Pip packages
ARG PACKAGE_MKDOCS="mkdocs==1.1.2"
ARG PACKAGE_PIP="pip==21.0.1"

# Install dependencies and tools
RUN apk add --update-cache --virtual .build-deps \
        ${PACKAGE_GCC} \
        ${PACKAGE_MUSL_DEV} && \
    apk add --virtual .tool-deps \
        ${PACKAGE_GIT} && \
    pip install \
        ${PACKAGE_PIP} \
        ${PACKAGE_MKDOCS} && \
    apk del --purge .build-deps && \
    rm -rf /var/cache/apk/*

WORKDIR "/var/www"
