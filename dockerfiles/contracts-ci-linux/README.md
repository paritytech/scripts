# contracts! CI for Linux Distributions

Docker image based on our base CI image `<base-ci:latest>`.

Used to build and test contracts!.

## Dependencies and Tools

- `llvm-dev`
- `clang-10`
- `zlib1g-dev`
- `npm`
- `yarn`
- `wabt`

**Inherited from `<base-ci:latest>`**

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

We always try to use the [latest possible](https://rust-lang.github.io/rustup-components-history/) `nightly` version that supports our required `rustup` components:

- `rustfmt`: The Rust code formatter.
- `rust-src`: The Rust sources of the standard library.

**Rust tools & toolchains:**

- `cargo-contract`
- `pwasm-utils-cli`
- `solang`
- `canvas-node`
- `wasm32-unknown-unknown`: The toolchain to compile Rust codebases for Wasm.

[Click here](https://hub.docker.com/repository/docker/paritytech/contracts-ci-linux) for the registry.

## Usage

```yaml
test-contracts:
    stage: test
        image: paritytech/contracts-ci-linux:production
        script:
            - cargo build ...
```
