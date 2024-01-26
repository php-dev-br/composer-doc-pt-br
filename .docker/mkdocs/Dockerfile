### dev ###

FROM python:3.9.18-alpine3.19 AS dev
LABEL maintainer="Adiel Cristo <adiel@adielcristo.com>"

# Install dependencies and tools.
RUN apk update && \
    apk add --no-cache --virtual .build-deps \
        gcc=13.2.1_git20231014-r0 \
        musl-dev=1.2.4_git20230717-r4 && \
    apk add --virtual .tool-deps \
        git=2.43.0-r0 && \
    pip install \
        pip==23.3.2 \
        mkdocs==1.5.3 \
        mkdocs-i18n==0.4.6 && \
    apk del --purge .build-deps

WORKDIR "/var/www"

### build ###

FROM dev AS build
LABEL maintainer="Adiel Cristo <adiel@adielcristo.com>"

# Set the image build commit.
ARG BUILD_COMMIT_SHA
ENV BUILD_COMMIT_SHA=${BUILD_COMMIT_SHA}

COPY . /var/www
WORKDIR /var/www

RUN mkdocs build && \
    echo "Commit: ${BUILD_COMMIT_SHA}"

### prod ###

FROM scratch AS prod
LABEL maintainer="Adiel Cristo <adiel@adielcristo.com>"

COPY --from=build /var/www/build /var/www/build
