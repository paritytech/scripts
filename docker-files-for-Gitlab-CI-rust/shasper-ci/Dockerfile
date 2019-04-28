FROM parity/rust-substrate-build:stretch

ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.maintainer="devops-team@parity.io" \
	org.label-schema.vendor="Parity Technologies" \
	org.label-schema.description="Image for Shasper CI builds and tests." \
	org.label-schema.vcs-ref="${VCS_REF}" \
	org.label-schema.name="parity/shasper-ci:stretch" \
	org.label-schema.url="https://hub.docker.com/r/paritytech/scripts/docker-files-for-Gitlab-CI-rust/shasper-ci/" \
	org.label-schema.vcs-url="https://github.com/paritytech/scripts/docker-files-for-Gitlab-CI-rust/shasper-ci/" \
	org.label-schema.build-date="${BUILD_DATE}"

WORKDIR /builds/parity/substrate/

ENV CARGO_HOME=/ci-cache/shasper/cargo \
	SCCACHE_DIR=/ci-cache/shasper/sccache
