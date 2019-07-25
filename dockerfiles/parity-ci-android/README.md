# Description
Docker images with preinstalled [RUST](https://www.rust-lang.org/) ARMv7 for [ANDROID](https://www.android.com/) for [GitLab CI runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Uses [sccache](https://github.com/mozilla/sccache).
# Usage
```linux-armv7-android:
      stage: build
      image: parity/parity-ci-android:stretch
      script:
        - cargo build ...
```
# Instructions
How to build parity client for arm64 arch:
```
git clone https://github.com/paritytech/parity-ethereum.git .
git submodule update --init --recursive
export CARGO_TARGET=armv7-linux-androideabi
export CI_SERVER_NAME=local
scripts/gitlab/build-linux.sh
```

