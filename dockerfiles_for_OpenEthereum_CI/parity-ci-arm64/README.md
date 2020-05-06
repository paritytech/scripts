# Description
Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARM64 for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
# Usage
```
    build-linux-arm64:
      stage: build
      image: registry.parity.io/parity/infrastructure/scripts/parity-ci-arm64:latest
      script:
        - cargo build build --target aarch64-unknown-linux-gnu $CARGO_OPTIONS
```
# Instructions
How to build parity client for arm64 arch:
```
git clone https://github.com/paritytech/parity-ethereum.git .
git submodule update --init --recursive
export CARGO_TARGET=aarch64-unknown-linux-gnu
export CI_SERVER_NAME=local
scripts/gitlab/build-linux.sh
```
