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

- `cargo-web`
- `cargo-hack`
- `cargo-nextest`
- `sccache`
- `wasm-pack`
- `wasm-bindgen`
- `cargo-deny`
- `cargo-spellcheck`: Required for the CI to do automated spell-checking.
- `wasm32-unknown-unknown` toolchain
- `mdbook mdbook-mermaid mdbook-linkcheck mdbook-graphviz mdbook-last-changed`

[Click here](https://hub.docker.com/repository/docker/paritytech/ci-linux) for the registry.

## Usage

```yaml
test-substrate:
    stage: test
        image: paritytech/ci-linux:production
        script:
            - cargo build ...
```

