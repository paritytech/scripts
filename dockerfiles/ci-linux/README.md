# ci-linux

Docker image based on our base CI image `<base-ci-linux:latest>`.

Used to build and test Substrate-based projects.

## Dependencies and Tools

- `chromium-driver`

**Inherited from `<base-ci-linux:latest>`:**

- `libssl-dev`
- `clang-7`
- `lld`
- `libclang-dev`
- `make`
- `cmake`
- `git`
- `pkg-config`
- `curl`
- `time`
- `rhash`
- `ca-certificates`

**Rust versions:**

- stable (default)
- nightly

**Rust tools & toolchains:**

- `cargo-audit`
- `cargo-web`
- `sccache`
- `wasm-pack`
- `wasm-bindgen`
- `cargo-deny`
- `wasm32-unknown-unknown` toolchain

[Click here](https://hub.docker.com/repository/docker/paritytech/ci-linux) for the registry.

## Usage

```yaml
test-substrate:
    stage: test
        image: paritytech/ci-linux
        script:
            - cargo build ...
```
