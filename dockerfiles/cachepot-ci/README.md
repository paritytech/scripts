# cachepot-ci

Docker image based on our base CI image `<base-ci:latest>`.

Used to build and test cachepot.

## Dependencies and Tools

- `linux-headers`
- `gcc`
- `binutils`
- `coreutils`
- `gdbserver`
- `zlib1g-dev`
- `librust-zip+deflate-miniz-dev`
- `gnupg2`
- `docker-cli`
- `cuda`

**Inherited from `<base-ci:latest>`**

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
- `broot`
- `ripgrep`
- `sd`

**Rust tools & toolchains:**

- stable (default)
- nightly
- `wasm32-unknown-unknown`: The toolchain to compile Rust codebases for Wasm.
- `sccache`: Caching system for Rust.
- `cargo-deny`: Checks licenses, dupe dependencies, vulnerability dDBs.

[Click here](https://hub.docker.com/repository/docker/paritytech/bridges-ci) for the registry.

## Usage

```yaml
test-ink:
    stage: test
        image: paritytech/cachepot-ci:production
        script:
            - cargo build ...
```

