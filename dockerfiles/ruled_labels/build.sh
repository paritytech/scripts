#!/usr/bin/env bash

ENGINE=${ENGINE:-podman}
echo "Using $ENGINE to build the container"

REPO=https://github.com/paritytech/ruled_labels
REGISTRY_PATH=${REGISTRY_PATH:-paritytech}
DOCKER_IMAGE_NAME=ruled_labels

REPO_TMP=$(mktemp -d)
echo "Cloning ${REPO} into ${REPO_TMP}"
git clone ${REPO} "${REPO_TMP}"

$ENGINE build \
    -t "${DOCKER_IMAGE_NAME}" \
    -t "${REGISTRY_PATH}/${DOCKER_IMAGE_NAME}" \
    "${REPO_TMP}"

$ENGINE images | grep "${DOCKER_IMAGE_NAME}"

# Testing
$ENGINE images | grep $DOCKER_IMAGE_NAME
$ENGINE run --rm -it ${DOCKER_IMAGE_NAME}
$ENGINE run --rm -it ${DOCKER_IMAGE_NAME} --version
