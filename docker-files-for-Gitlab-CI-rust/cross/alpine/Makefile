#IMAGE for build rust-alpine
#Created by Parity Technologies <devops@parity.io>
USER=parity
NAME=rust-alpine
TAG=latest

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rust-alpine image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build alpine-centos image"
	@echo "  make push          - push built image to the regitry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push
