FROM ubuntu:xenial as builder

# metadata
LABEL maintainer="devops-team@parity.io" \
	vendor="Parity Technologies" \
	name="parity/rust-parity-ethereum-docs" \
	description="Image for CI docs stage for Parity Ethereum." \
	url="https://gitlab.com/paritytech/scripts/" \
	vcs-url="scripts/docker-files-for-Gitlab-CI-rust/parity-eth-linux-docs"

WORKDIR /builds/parity/parity-ethereum/

# install tools and dependencies
RUN set -eux; \
	apt-get -y update; \
    apt-get install -y --no-install-recommends \
		curl ca-certificates git; \
# install nodejs and yarn
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
	apt-get -y update; \
	apt-get install -y --no-install-recommends \
		nodejs yarn; \
	# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*
