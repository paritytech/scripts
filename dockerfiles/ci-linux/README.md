# ci-linux

Docker image based on our base CI image `<base-ci:latest>`.

Used to build and test Substrate-based projects.

## Dependencies and Tools

**Inherited from `<base-ci:latest>`:**

- `libssl-dev`
- `clang-10`
- `clang++-10`
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
- `jq`

**Rust versions:**

- stable (default)
- nightly

**Rust tools & toolchains:**

- `diener`
- `sccache`
- `cargo-clippy`
- `cargo-deny`
- `cargo-spellcheck`: Required for the CI to do automated spell-checking
- `wasm32-unknown-unknown` toolchain
- `wasm-pack`
- `wasm-bindgen`
- `wasm-gc`

[Click here](https://hub.docker.com/repository/docker/paritytech/ci-linux) for the registry.

## Usage

```yaml
test-substrate:
    stage: test
        image: paritytech/ci-linux:production
        script:
            - cargo build ...
```
