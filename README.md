# scripts

Various helpful scripts 


## get-parity.sh

Download, verify and install 
[parity-ethereum](https://github.com/paritytech/parity-ethereum/).


## Dockerfiles for images used in GitLab CI
[Documentation](dockerfiles/README.md).
Rust and tools for:
 - Substrate-based Cis
 - parity-ethereum CI
 - android
 - arm64
 - armv7
 - i686


## GitLab CI for building docker images

Pipelines can only be triggered manually for now. For that go to the projects 
CI/CD -> Pipelines menu and click "Run Pipeline". Variables have to be given 
to select the image to build. E.g.

```
parity/$CONTAINER_IMAGE="parity/parity-ci-linux"
$CONTAINER_TAG="nightly"
```

Docker image parity/rust:nightly is set up to be rebuild every night.

