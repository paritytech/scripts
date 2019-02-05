Docker image based on [RUST](https://www.rust-lang.org/) rust:stretch image (latest stable), [node.js](https://nodejs.org), for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```
linux-stable:
    stage: build
    image: parity/rust-linux:stretch
    script:
      - cargo build ...
```
