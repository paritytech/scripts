# MUSL CI for Linux Distributions

Docker image based on our base CI image `<base-ci-linux:latest>`.

Used to build and test MUSL target.

## Dependencies and Tools

- `openssl`
- `zlib`
- `[musl tools](https://musl.cc/)`

**Inherited from `<base-ci-linux:latest>`:**

- `libssl-dev`
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
- `cargo`
- `rustfmt`

The [`rustup` component history](https://rust-lang.github.io/rustup-components-history/) provides a decent overview to decide upon a new version update.

**Rust tools & toolchains:**

- `x86_64-unknown-linux-musl` toolchain

[Click here](https://hub.docker.com/repository/docker/paritytech/musl-ci-linux) for the registry.

## Usage

```yaml
test-contracts:
    stage: test
        image: paritytech/musl-ci-linux:latest
        script:
            - cargo build ...
```
