FROM python:3.10

# metadata
ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
LABEL io.parity.image.authors="devops-team@parity.io" \
        io.parity.image.vendor="Parity Technologies" \
        io.parity.image.title="${REGISTRY_PATH}/molecule" \
        io.parity.image.description="ansible" \
        io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/molecule/Dockerfile" \
        io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/molecule/README.md" \
        io.parity.image.revision="${VCS_REF}" \
        io.parity.image.created="${BUILD_DATE}"

RUN pip install --no-cache-dir  \
    ansible \
    ansible-lint==6.0.1 \
    yamllint \
    "molecule[docker]"==3.6.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       docker.io jq \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Do not switch to nonroot user, molecule have to connect to docker engine anyway.
# nonroot will create a false fealing of security.
