# Base image
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
    bash \
    git \
    http://dl-cdn.alpinelinux.org/alpine/edge/testing hub

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]