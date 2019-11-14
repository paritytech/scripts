# Ink-ci-linux

Docker image based on our substrate builder `<parity/rust-builder:latest>`.

Used to build and test ink!.

## Dependencies and Tools

**Inherited from `<parity/rust-builder:latest>`:**

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

**Others:**

- `cargo-kcov`
- `clippy`
- `libcurl4-openssl-dev`
- `libelf-dev`
- `libdw-dev`
- `python3`
- `kcov`
- `rust nightly-2019-10-03`
- `rustfmt`
- `zlib1g-dev`

**Rust versions:**

- nightly-2019-11-13 (default)
- stable (unsupported)
- nightly (partly supported, some nightlies might break)

**Rust tools & toolchains:**

- `cargo-audit`
- `cargo-web`
- `clippy`
- `rustfmt`
- `sccache`
- `wasm-pack`
- `wasm32-unknown-unknown` toolchain

[Click here](https://registry.parity.io/parity/infrastructure/scripts/ink-ci-linux) for the registry.

## Usage

```
test-ink:
    stage: test
        image: registry.parity.io/parity/infrastructure/scripts/ink-ci-linux
        script:
            - cargo build ...
```
