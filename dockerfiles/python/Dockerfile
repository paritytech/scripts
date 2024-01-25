FROM docker.io/library/python:3.12

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG VAULT_VERSION

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/python" \
	io.parity.image.description="python; vault;" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/terraform/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN	curl "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" \
	-o vault.zip; \
	unzip vault.zip	-d /usr/local/bin/ vault; \
	rm vault.zip; \
	chmod +x /usr/local/bin/vault

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       docker.io jq \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

ARG WORKDIR=/work
RUN groupadd --gid 10001 nonroot && \
    useradd  --home-dir /home/nonroot \
             --create-home \
             --shell /bin/bash \
             --gid nonroot \
             --groups nonroot \
             --uid 10000 nonroot
RUN chown -R nonroot. /home/nonroot
RUN mkdir ${WORKDIR}
RUN chown -R nonroot. ${WORKDIR}
USER 10000:10001
WORKDIR ${WORKDIR}

USER nonroot:nonroot
CMD ["/bin/bash"]
