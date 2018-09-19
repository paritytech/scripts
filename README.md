# scripts

Various helpful scripts 


## get-parity.sh

Download, verify and install 
[parity-ethereum](https://github.com/paritytech/parity-ethereum/).


## Dockerfiles for images used in GitLab CI
[Documentation](docker-files-for-Gitlab-CI-rust/README.md).

 - rust image
 - android
 - arm
 - arm64
 - armv7
 - centos
 - debian
 - i686
 - snapcraft


## GitLab CI for building docker images

Pipelines can only be triggered manually for now. For that go to the projects 
CI/CD -> Pipelines menu and click "Run Pipeline". Variables have to be given 
to select the image to build. E.g.

```
DOCKERIMAGE="rust"
DOCKERTAG="nightly"
```

Docker image parity/rust:nightly is set up to be rebuild every night.

