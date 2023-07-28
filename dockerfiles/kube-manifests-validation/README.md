# kube-manifests-validation

Docker image based on [official Debian image](https://hub.docker.com/_/debian) debian:12-slim.

A base image with the tools for validating Kubernetes manifests using Gator and Datree CLI utilities

**Tools:**

- `curl`
- `git`
- `moreutil`
- `zip`
- `gator`
- `datree`

[Click here](https://hub.docker.com/repository/docker/paritytech/kube-manifests-validation) for the registry.

## Usage

```Dockerfile
FROM docker.io/paritytech/kube-manifests-validation:latest
```
