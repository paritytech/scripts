# Ink-ci-linux

Docker image based on our base CI image `<base-ci-linux:latest>`.

Used to build and test ink!.

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

- nightly-2019-11-17 (default)
- stable (unsupported)

**Rust tools & toolchains:**

- `clippy`
- `rustfmt`
- `sccache`
- `cargo-contract`
- `wasm32-unknown-unknown` toolchain

[Click here](https://registry.parity.io/parity/infrastructure/scripts/ink-ci-linux) for the registry.

## Usage

```yaml
test-ink:
    stage: test
        image: registry.parity.io/parity/infrastructure/scripts/ink-ci-linux:latest
        script:
            - cargo build ...
```
