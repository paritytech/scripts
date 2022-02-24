ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=docker.io/paritytech

# `production` tag is used here to base off the image that has already been tested against
# the `ink` CI. This reduces the maintenance of fixing the same nightly stuff in both images.
FROM ${REGISTRY_PATH}/ink-ci-linux:production

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-waterfall-ci" \
	io.parity.image.description="Inherits from docker.io/paritytech/ink-ci-linux." \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-waterfall-ci/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-waterfall-ci/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND=noninteractive

RUN	set -eux; \
	apt-get -y update && \
	apt-get install -y --no-install-recommends \
# `redis-cli` is needed to interact with ci/cd's redis
	redis-tools \
# npm is needed to install `yarn`
	npm \
# `firefox` is needed to simulate interactions with the `canvas-ui`
	firefox && \
# `geckodriver` is needed to run headless browser tests
# we fetch the latest version number from the github api and use that release
	curl --silent https://api.github.com/repos/mozilla/geckodriver/releases/latest | \
		egrep --only-matching 'https://github.com/mozilla/geckodriver/releases/download/v[0-9.]+/geckodriver-v[0-9.]+-linux64.tar.gz' | \
		head -n1 | \
		xargs curl -L -O && \
	tar -xvzf geckodriver-v*-linux64.tar.gz && \
	rm geckodriver-v*-linux64.tar.gz && \
	chmod +x geckodriver && \
	mv geckodriver /usr/local/bin/ && \
# `yarn` is needed to run `canvas-ui`
	npm install --ignore-scripts -g yarn && \
# `cargo-dylint` and `dylint-link` are dependencies needed to run `cargo-contract`.
	cargo install cargo-dylint dylint-link && \
# `cargo-contract` is needed for building those examples. Here it's
# force-rewritten above the stable version from the parent image.
# `--force` rewrites the stable version installed in the parent image.
# `--locked` ensures the project's `Cargo.lock` is used.
	cargo install --git https://github.com/paritytech/cargo-contract \
		--locked --branch master --force && \
# `substrate-contracts-node` is a Substrate chain with smart contract functionality.
# `--locked` ensures the project's `Cargo.lock` is used.
	cargo install --git https://github.com/paritytech/substrate-contracts-node.git \
		--locked --branch main && \
# We additionally install the `substrate-contracts-node` as `substrate-contracts-rand-extension`.
# This installation though is a modified `substrate-contracts-node`, so that ink!'s
# `rand-extension` chain extension example is included in the runtime.
# This enables us to test in the waterfall that the `rand-extension`
# integration with Substrate still works.
	git clone --depth 1 https://github.com/paritytech/substrate-contracts-node.git && \
	curl -s https://raw.githubusercontent.com/paritytech/ink/master/examples/rand-extension/runtime/chain-extension-example.rs \
		>> substrate-contracts-node/runtime/src/lib.rs && \
	sed -i 's/type ChainExtension = ();/type ChainExtension = FetchRandomExtension;/g' substrate-contracts-node/runtime/src/lib.rs && \
	sed -i 's/name = "substrate-contracts-node"/name = "substrate-contracts-node-rand-extension"/g' substrate-contracts-node/node/Cargo.toml && \
	cargo install --locked --path substrate-contracts-node/node/ && \
# Needed for regression testing, a CSV contains the sizes of compiled contracts.
	cargo install --git https://github.com/paritytech/ink-waterfall.git csv-comparator && \
	npm install -g csv2md && \
# versions
	rustup show && \
	cargo --version && \
	cargo-contract --version && \
	substrate-contracts-node --version && \
	substrate-contracts-node-rand-extension --version && \
# Clean up and remove compilation artifacts that a cargo install creates (>250M).
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache && \
# Clean up artifacts of `substrate-contracts-rand-extension` installation
	rm -rf substrate-contracts-node/ && \
# apt clean up
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# TODO: https://gitlab.parity.io/parity/infrastructure/scripts/-/jobs/958687
# USER nonroot:nonroot
