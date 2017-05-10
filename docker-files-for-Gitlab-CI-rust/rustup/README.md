Docker images with preinstalled [RUST](https://www.rust-lang.org/) (stable - default, beta, nightly), [node.js](https://nodejs.org), [https://www.oracle.com/java/index.html](Oracle JDK1.8 (Java 8) ) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```linux-stable:
      stage: build
      image: parity/rust:gitlab-ci
      script:
        - rustup default stable
        - cargo build ...
```
