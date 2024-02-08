DOCKER_ORG        ?= umatare5
DOCKER_IMAGE_NAME ?= hey-yo-http
DOCKER_IMAGE_TAG  ?= $(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))

.PHONY: build
build:
	@echo ">> building binaries into ./dist/$(DOCKER_IMAGE_NAME)"
	@go build -o "./dist/$(DOCKER_IMAGE_NAME)"

.PHONY: docker-image
docker-image:
	@echo ">> building docker image"
	@docker build -t "$(DOCKER_ORG)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" .
