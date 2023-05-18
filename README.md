# Parity Scripts & Dockerfiles

Nowadays, this repo is mostly the open collection of the company's Dockerfiles that are used by Parity in different ways. If you work on a Substrate-based project, you could be interested in our CI images (`ci-unified`, `ci-linux`) in the `dockerfiles` directory.

#### But what about scripts?

`scripts` is mostly is a legacy name. Yes, this repo contains some scripts, but they are mostly kept here for historical reasons. We are not actively maintaining them. If you are looking for something specific, please, open an issue and we will try to help you.

### Additional information

* We use the `ci-linux` image for our "major" CI (Substrate, Polkadot, Cumulus). It is built on top of `base-ci-linux` image. You can find more information about them in the `dockerfiles` directory.
* Most of the images are published to Docker Hub and could be found [here](https://hub.docker.com/u/paritytech).
* If you have access to Parity's internal GitLab, please have a look at this project's pipeline schedules. You can use them to build Docker/OCI images on demand.

### Legacy notes

* [Reproduce CI locally](https://github.com/paritytech/scripts/blob/docs/legacy/reproduce_ci_locally.md)
