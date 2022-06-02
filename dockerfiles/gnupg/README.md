# gnupg

Docker image based on [official Ubuntu image](https://hub.docker.com/_/ubuntu) ubuntu:latest.
Used as base for tooling that requires gnupg. GPG usually requires working with the gpg-agent.
Using the gpg-agent in a rootless context can be challenging as you will need to align the UID
in the container with the UIDs of your local system.

While we could make an image with UID that could be passed as ARG, this will likely always endup
being the wrong UID. For this reason, this image is creating the users at runtime.
By default, the UID is `9001` but you may customize it using the `LOCAL_USER_ID` environment variable.

This will allow downstream images such as `paritytech/rpm` and `paritytech/deb` to be ran with the "right"
UID and allows mapping the gpg-agent socket for the right UID.

**Tools:**

- `curl`
- `gnupg`

[Click here](https://hub.docker.com/repository/docker/paritytech/gnupg) for the registry.

## Usage

```Dockerfile
FROM docker.io/paritytech/gnupg:latest
```

## Tests

You need to install [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) then run:
```
container-structure-test test --image $REGISTRY_PATH/gnupg --config tests/quick.yaml
```
