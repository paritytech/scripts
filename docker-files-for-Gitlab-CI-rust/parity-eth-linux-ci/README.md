Docker image with latest stable, beta and nightly [RUST](https://www.rust-lang.org/)  based on ubuntu:xenial image for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
Usage:
```
linux-stable:
    stage: build
    image: parity/rust-parity-ethereum-build:xenial
    script:
      - cargo build ...
```
