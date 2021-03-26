FROM ubuntu:xenial as builder

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity-ci-docs" \
	io.parity.image.description="curl ca-certificates git; nodejs yarn" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles_for_OpenEthereum_CI/parity-ci-docs/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles_for_OpenEthereum_CI/parity-ci-docs/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds/parity/parity-ethereum/

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
    apt-get install -y --no-install-recommends \
		curl ca-certificates git; \
# install nodejs and yarn
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		nodejs; \
	npm install --ignore-scripts -g yarn; \
	# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*
