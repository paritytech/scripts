ARG REGISTRY_PATH=docker.io/paritytech

FROM docker.io/library/ubuntu:latest

ARG VCS_REF=master
ARG BUILD_DATE=""

# metadta
LABEL summary="Base image with git and gh (GitHub CLI)" \
	name="${REGISTRY_PATH}/github-gh-cli" \
	maintainer="devops-team@parity.io" \
	version="1.0" \
	description="Image contains git and gh tools." \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/dockerfiles/github-gh-cli/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/github-gh-cli/gnupg/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

RUN apt-get update && apt-get install -yq --no-install-recommends bash ca-certificates git gh; \
    # verify gh binary works
    gh --version;

WORKDIR /tmp/repo

CMD ["gh"]
