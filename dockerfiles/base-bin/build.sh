#!/usr/bin/env bash

ENGINE=podman
IMAGE=parity/base-bin
REGISTRY=${REGISTRY:-docker.io}

$ENGINE build \
    --build-arg BUILD_DATE=$(date +%Y%m%d) \
    --build-arg USER=parity \
    -t $REGISTRY/parity/$IMAGE \
    -t $REGISTRY/$USER/$IMAGE \
    -t $REGISTRY/$IMAGE \
    .
$ENGINE images | grep $IMAGE
$ENGINE run --rm -it -h $IMAGE $IMAGE bash -c 'uname -a; echo "Last updated:"; cat /var/lastupdate'
