# ink! CI for Linux Distributions

Docker image based on our base CI image `<base-ci-linux:latest>`.

Used to build and test ink!.

## Dependencies and Tools

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

We always try to use the latest possible `nightly` version that supports our required `rustup` components:

- `clippy`
- `rust-src`
- `miri`
- `cargo`
- `rustfmt`

The [`rustup` component history](https://rust-lang.github.io/rustup-components-history/) provides a decent overview to decide upon a new version update.

**Rust tools & toolchains:**

- `grcov`
- `rust-covfix`
- `cargo-contract`
- `wasm32-unknown-unknown` toolchain

[Click here](https://hub.docker.com/repository/docker/paritytech/ink-ci-linux) for the registry.

## Usage

```yaml
test-ink:
    stage: test
        image: paritytech/ink-ci-linux:latest
        script:
            - cargo build ...
```
