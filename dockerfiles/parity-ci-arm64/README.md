Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARM64 for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
Usage:
```
    build-linux-arm64:
      stage: build
      image: parity/parity-ci-arm64:latest
      script:
        - cargo build build --target aarch64-unknown-linux-gnu $CARGO_OPTIONS
```
