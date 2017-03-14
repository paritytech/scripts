#IMAGE for build rust arm* arch
#Created by Denis S. Soldatov aka General-Beck general-beck@ethcore.io
USER=ethcore
NAME=rust-aarch64
TAG=latest

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rustup arm image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build rustup arm image"
	@echo "  make push          - push built image to the regitry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push

