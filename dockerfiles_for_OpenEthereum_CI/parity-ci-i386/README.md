# Description
Docker images with preinstalled [RUST](https://www.rust-lang.org/) i686 for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
# Usage
```
    build-linux-i386:
      stage: build
      image: registry.parity.io/parity/infrastructure/scripts/parity-ci-i386:latest
      script:
        - cargo build --target i686-unknown-linux-gnu $CARGO_OPTIONS
```
# Instructions
How to build parity client for arm64 arch:
```
git clone https://github.com/paritytech/parity-ethereum.git .
git submodule update --init --recursive
export CARGO_TARGET=i686-unknown-linux-gnu
export CI_SERVER_NAME=local
scripts/gitlab/build-linux.sh
```
