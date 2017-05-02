Stable (default), beta, nightly toolchains for Docker images with preinstalled [RUST](https://www.rust-lang.org/) (), [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner). [parity/rust](https://hub.docker.com/r/parity/rust/)
Usage:
```linux-stable:
      stage: build
      image: parity/rust:gitlab-ci
      script:
        - rustup default stable
        - cargo build ...
```
