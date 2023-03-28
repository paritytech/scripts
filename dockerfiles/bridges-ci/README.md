# bridges-ci

Docker image based on our base CI image `<base-ci-linux>`.

Used to build and test parity-bridges-common.

## Dependencies and Tools

**Inherited from `<base-ci-linux>`**

- `libssl-dev`
- `clang-10`
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

We always use the [latest possible](https://rust-lang.github.io/rustup-components-history/) `nightly` version that supports our required `rustup` components:

- `clippy`: The Rust linter.
- `rustfmt`: The Rust code formatter.

**Rust tools & toolchains:**

- stable (default)
- `wasm32-unknown-unknown`: The toolchain to compile Rust codebases for Wasm.
- `sccache`: Caching system for Rust.
- `cargo-deny`: Checks licenses, dupe dependencies, vulnerability dDBs.

[Click here](https://hub.docker.com/repository/docker/paritytech/bridges-ci) for the registry.

## Usage

```yaml
test-ink:
    stage: test
        image: paritytech/bridges-ci:production
        script:
            - cargo build ...
```

