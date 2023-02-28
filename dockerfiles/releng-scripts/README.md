# releng-scripts

Docker image based on [official Ubuntu image](https://hub.docker.com/_/ubuntu) ubuntu:latest.

This is an image for the scripts located in this repo: https://github.com/paritytech/releng-scripts

## Build

The provided `build.sh` script clones [the repo](https://github.com/paritytech/releng-scripts) and builds the image.

## Usage

```bash
# Show the help
docker run --rm -it paritytech/releng-scripts
# Show the version
docker run --rm -it paritytech/releng-scripts version
```
