# scripts

Various helpful scripts

## Dockerfiles for images used in GitLab CI

[Documentation](dockerfiles/README.md).
Rust and tools for:

- Substrate-based projects CIs
- android
- arm64
- armv7
- i686
- docs autogeneration
- various tools
- tools for kubernetes

## GitLab CI for building docker images

Pipelines are triggered by schedule. Can be launched manually though.
To launch the pipeline go to the project's CI/CD -> Schedules menu.
To change, edit/create the new schedule:
    set the required variable and cron schedule.

## Reproduce CI locally

### Preparation

1.  [install `podman`](https://podman.io/getting-started/installation) (it's rootless) or rename it to `docker` in the following snippet
2.  Consider the [following snippets](https://github.com/paritytech/scripts/tree/master/snippets) pick one depending on which shell you use.

TLDR; the function runs the named container in the current dir with  
      - redirecting the current directory into the image  
      - keeping your shell history on your host  
      - keeping Rust caches on your host, so you build faster the next time  
    example use: `cargoenvhere paritytech/ci-linux:production /bin/bash -c 'RUSTFLAGS="-Cdebug-assertions=y -Dwarnings" RUST_BACKTRACE=1 time cargo test --workspace --locked --release --verbose --features runtime-benchmarks --manifest-path bin/node/cli/Cargo.toml'`

### Execution

1.  open the CI config file (`.gitlab-ci.yml`)
2.  note `CI_IMAGE:` variable value there (for example `paritytech/contracts-ci-linux:production`)
3.  look for the job you want to reproduce and see if `*docker-env` or `image:` is mentioned there (then you should use this one)
4.  note global and in-job `variables:`, in order to reproduce the job closely you might want to run it with the same `RUSTFLAGS` and `CARGO_INCREMENTAL`
5.  `podman pull [CI image name]` / `docker pull [CI image name]`
6.  execute your job how it's shown in the example ^ `cargoenvhere [CI image name] /bin/bash -c ‘[cargo build ...]’`
7.  find your artifacts in `/home/$USER/cache/[project name or current dir name]/target` for Linux users or `/path/to/the/cloned/repo/target` for OS X users.

:warning: If you want to execute a binary on OS X pay attention that with docker it is compiled for Linux. So if want to run it you need to use something like:  
`cargoenvhere paritytech/contracts-ci-linux:production cargo run`
