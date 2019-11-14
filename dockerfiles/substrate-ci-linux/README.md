# substrate-ci-linux

Docker image based on our base CI image `<base-ci-linux:latest>`.

Used to build and test Substrate-based projects.

## Dependencies and Tools

**Inherited from `<base-ci-linux:latest>`:**

- `clang-8`
- `cmake`
- `curl`
- `g++`
- `gcc`
- `git`
- `libssl-dev`
- `make`
- `pkg-config`
- `rhash`
- `rust-builder`
- `time`

**Rust versions:**

- stable (default)
- nightly

**Rust tools & toolchains:**

- `cargo-audit`
- `cargo-web`
- `sccache`
- `wasm-pack`
- `wasm32-unknown-unknown` toolchain

[Click here](https://registry.parity.io/parity/infrastructure/scripts/substrate-ci-linux) for the registry.

## Usage

```yaml
test-substrate:
    stage: test
        image: registry.parity.io/parity/infrastructure/scripts/substrate-ci-linux
        script:
            - cargo build ...
```
