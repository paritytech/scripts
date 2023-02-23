# CI image for [`smart-bench`](https://github.com/paritytech/smart-bench/)

Docker image based on our base CI image `<ink-ci-linux:production>`.

Used to build and run benchmarks of smart contracts on a parachain.

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
- `cargo-dylint` and `dylint-link`: Required to run `cargo-contract`.
- `wasm32-unknown-unknown`: The toolchain to compile a Rust codebase for Wasm.

[Click here](https://hub.docker.com/repository/docker/paritytech/smart-bench-ci) for the registry.

## Usage

```yaml
test-ink:
    stage: test
        image: paritytech/smart-bench-ci:latest
        script:
            - cargo build ...
```

