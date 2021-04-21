# ink! waterfall CI for Linux Distributions

Docker image based on our base CI image `<ink-ci-linux:production>`.

Used to build and run end-to-end tests for ink!, `cargo-contract`, `canvas-node` and `canvas-ui`.

## Dependencies and Tools

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

We always use the [latest possible](https://rust-lang.github.io/rustup-components-history/) `nightly` version that supports our required `rustup` components:

- `clippy`: The Rust linter.
- `rust-src`: The Rust sources of the standard library.
- `rustfmt`: The Rust code formatter.

**Rust tools & toolchains:**

- `cargo-contract`: Required to build ink! Wasm smart contracts.
- `canvas-node`: Required to run a Substrate chain for smart contracts.
- `wasm32-unknown-unknown`: The toolchain to compile Rust codebases for Wasm.

[Click here](https://hub.docker.com/repository/docker/paritytech/ink-waterfall-ci) for the registry.

## Usage

```yaml
test-ink:
    stage: test
        image: paritytech/ink-waterfall-ci:latest
        script:
            - cargo build ...
```
