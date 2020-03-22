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
- `ca-certificates`
- `firefox-esr`
- `geckodriver`

**Rust versions:**

- stable (default)
- nightly

[Click here](https://hub.docker.com/repository/docker/parity/rust-builder) for the registry.

**Rust tools & toolchains:**

- `cargo-audit`
- `cargo-web`
- `sccache`
- `wasm-pack`
- `wasm-bindgen`
- `cargo-deny`
- `wasm32-unknown-unknown` toolchain

## Usage

```yaml
build-substrate:
    stage: build
        image: parity/rust-builder:latest
        script:
            - rustup default stable
            - cargo build ...
```
