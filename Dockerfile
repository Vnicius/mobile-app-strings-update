# Base image
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
    bash \
    git

FROM golang:1.9.2 as builder
RUN set -xe && \
    go get -u -d github.com/github/hub && \
    cd /go/src/github.com/github/hub && \
    git remote add jsternberg git://github.com/jsternberg/hub && \
    git pull jsternberg master && \
    go install github.com/github/hub

FROM buildpack-deps:stretch-scm
COPY --from=builder /go/bin/hub /usr/bin/hub
COPY hub.sh /etc/profile.d/hub.sh    

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]