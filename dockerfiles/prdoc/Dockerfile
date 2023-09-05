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
ARG USER=ci
ARG BINARY="prdoc"

LABEL io.parity.image.authors="cicd-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/${BINARY}" \
    io.parity.image.description="${BINARY}" \
    io.parity.image.source="https://github.com/paritytech/${PROJECT_NAME}/blob/${VCS_REF}/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/${PROJECT_NAME}/blob/${VCS_REF}/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

WORKDIR /usr/local/bin

COPY --from=builder /app/target/$PROFILE/$BINARY /usr/local/bin

RUN useradd -m -u 1000 -U $USER && \
    apt-get -y update && \
    apt-get -y install openssl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

USER $USER
ENTRYPOINT [ "prdoc" ]
