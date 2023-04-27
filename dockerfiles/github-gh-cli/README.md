# GitHub CLI

Docker image based on [official Ubuntu image](https://hub.docker.com/_/ubuntu) ubuntu:latest.

Used as base for tooling that requires git and gh.

**Tools:**

- `git`
- `gh`

[Click here](https://hub.docker.com/repository/docker/paritytech/github-gh-cli) for the registry.

## Usage

```
docker run --rm -it -v $PWD:/tmp/repo docker.io/paritytech/github-gh-cli gh {needed_gh_command}
```
