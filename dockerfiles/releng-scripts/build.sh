#!/usr/bin/env bash

REPO=https://github.com/paritytech/releng-scripts
REGISTRY_PATH=${REGISTRY_PATH:-paritytech}
DOCKER_IMAGE_NAME=releng-scripts

REPO_TMP=$(mktemp -d)
echo "Cloning ${REPO} into ${REPO_TMP}"
git clone ${REPO} "${REPO_TMP}"

docker build \
    -t "${DOCKER_IMAGE_NAME}" \
    -t "${REGISTRY_PATH}/${DOCKER_IMAGE_NAME}" \
    "${REPO_TMP}"

docker images | grep "${DOCKER_IMAGE_NAME}"

# Testing
docker run --rm -it ${DOCKER_IMAGE_NAME}
docker run --rm -it ${DOCKER_IMAGE_NAME} version
