# Rust-builder

Docker image based on [official Debian image](https://hub.docker.com/_/debian) debian:buster.

Used to build and test `Substrate`-based projects.

**Dependencies and Tools:**

- `clang`
- `libclang-dev`
- `lld`
- `cmake`
- `curl`
- `git`
- `libssl-dev`
- `make`
- `pkg-config`
- `rhash`
- `rust-builder`
- `time`
- `firefox`

**Rust versions:**

- stable (default)
- nightly

[Click here](https://registry.parity.io/parity/infrastructure/scripts/base-ci-linux) for the registry.

**Rust tools & toolchains:**

- `sccache`

## Usage

```yaml
build-substrate:
    stage: build
        image: parity/rust-builder:latest
        script:
            - rustup default stable
            - cargo build ...
```
