FROM docker.io/paritytech/ci-linux:production as builder

ARG PROFILE=release
WORKDIR /app

COPY . .

RUN cargo build --profile ${PROFILE} --bins

# MAIN IMAGE FOR PEOPLE TO PULL --- small one #
FROM docker.io/parity/base-bin

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH="docker.io/paritytech"
ARG PROFILE=production
ARG USER=parity
ARG BINARY=prdoc
ARG DOCKER_IMAGE_NAME=prdoc

LABEL io.parity.image.authors="cicd-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/${DOCKER_IMAGE_NAME}" \
    io.parity.image.description="${DOCKER_IMAGE_NAME}" \
    io.parity.image.source="https://github.com/paritytech/${PROJECT_NAME}/blob/${VCS_REF}/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/${PROJECT_NAME}/blob/${VCS_REF}/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

WORKDIR /usr/local/bin

COPY --from=builder /app/target/$PROFILE/$BINARY /usr/local/bin

USER $USER
ENTRYPOINT [ "prdoc" ]
