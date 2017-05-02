Docker images with preinstalled [RUST](https://www.rust-lang.org/) stable Ubuntu Trusty,[Ethereum EVM JIT](https://github.com/ethereum/evmjit), [node.js](https://nodejs.org) and [AWS CLI](https://aws.amazon.com/ru/cli/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Usage:
```linux-stable:
      stage: build
      image: parity/rustup-jit:gitlab-ci
      script:
        - cargo build ...
```
