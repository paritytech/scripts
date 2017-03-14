#IMAGE for build rustup
#Created by Denis S. Soldatov aka General-Beck general-beck@ethcore.io
USER=ethcore
NAME=rustup-jit
TAG=latest

IMAGE=${USER}/${NAME}:${TAG}

help:
	@echo "Build rustup-jit image."
	@echo
	@echo "Usage:"
	@echo "  make [help]        - display this message"
	@echo "  make image         - build rustup-jit image"
	@echo "  make push          - push build image to the regitry"

image:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

.PHONY: help image push
