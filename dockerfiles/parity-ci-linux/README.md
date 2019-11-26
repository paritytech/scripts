# Parity-ci-linux

Docker image based on [Ubuntu:xenial](https://hub.docker.com/_/ubuntu).

Runs builds and tests `Parity Ethereum`.

Dependencies and tools: `g++`, `libssl-dev`, `gcc`, `clang-9`, `libc6-dev`, `make`, `cmake`, `libudev-dev`, `ca-certificates`, `git`, `pkg-config`, `curl`, `time`, `rhash`.

Rust versions: stable - default, beta, nightly.

Rust tools: `cargo-audit`, `sccache`.
Usage:
```
build-linux:
    stage: build
    image: registry.parity.io/parity/infrastructure/scripts/parity-ci-linux:latest
    script:
      - cargo build ...
```
