#
# Dockerfile for udpspeeder
#

FROM alpine:3.9
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk upgrade \
 && apk add --no-cache --virtual .build-deps \
      linux-headers \
      git \
      gcc \
      g++ \
      make \
 # Build & install
 && mkdir -p /tmp/repo \
 && cd /tmp/repo \
 && git clone https://github.com/wangyu-/UDPspeeder.git \
 && cd UDPspeeder \
 && make \
 && install speederv2 /usr/local/bin \
 && cd / \
 && rm -rf /tmp/repo \
 && apk del .build-deps \
 && speederv2 --help

USER root

ENTRYPOINT [ "speederv2" ]
