# Parity Scripts & Dockerfiles

Nowadays, this repo is mostly the open collection of the company's Dockerfiles that are used by Parity in different ways. If you work on a Substrate-based project, you could be interested in our CI image (`ci-unified`) in the `dockerfiles` directory.

#### But what about scripts?

`scripts` mostly is a legacy name. Yes, this repo contains some scripts, but they are kept here for historical reasons. We are not actively maintaining them. If you are looking for something specific, please, open an issue and we will try to help you.

### Additional information

* We use the `ci-unified` image for most of our CI pipelines (including the pipelines for Substrate-based/Substrate-related projects and Substrate itself). You can find more information about the image in the `dockerfiles/ci-unified` directory.
* Most of the images are published to Docker Hub and could be found [here](https://hub.docker.com/u/paritytech).
* If you have access to Parity's internal GitLab, please have a look at this project's pipeline schedules. You can use them to build Docker/OCI images on demand.

### Legacy notes

* [Reproduce CI locally](https://github.com/paritytech/scripts/blob/master/docs/legacy/reproduce_ci_locally.md)
