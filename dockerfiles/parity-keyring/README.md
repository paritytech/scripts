# parity-keyring

A base Docker image based on [our gnupg image](https://hub.docker.com/repository/docker/paritytech/gnupg) and coming pre-installed with the parity keyring.

[Click here](https://hub.docker.com/repository/docker/paritytech/parity-keyring) for the registry.

## Usage

```
docker run --rm -it docker.io/paritytech/parity-keyring gpg --list-keys $KEY_ID
```

