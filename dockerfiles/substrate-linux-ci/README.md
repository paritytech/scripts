Docker image with latest stable [RUST](https://www.rust-lang.org/) based on rustlang/rust:nightly-slim image for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
Usage:
```
linux-stable:
    stage: build
    image: parity/rust-substrate-build:stretch
    script:
      - cargo build ...
```
