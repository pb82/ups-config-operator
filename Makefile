APP_NAME = ups-sidecar
DOCKER_LATEST_TAG = docker.io/aerogear/$(APP_NAME):latest
RELEASE_TAG ?= $(CIRCLE_TAG)
DOCKER_RELEASE_TAG = aerogear/$(APP_NAME):$(RELEASE_TAG)

.PHONY: generate
generate:
	./scripts/generate.sh

.PHONY: build_linux
build_linux:
	env GOOS=linux GOARCH=amd64 go build cmd/server/main.go cmd/server/types.go cmd/server/upsClient.go

.PHONY: docker_build
docker_build: build_linux
	docker build -t $(DOCKER_LATEST_TAG) -f Dockerfile .

.PHONY: docker_build_release
docker_build_release:
	docker build -t $(DOCKER_LATEST_TAG) -t $(DOCKER_RELEASE_TAG) -f Dockerfile .

.PHONY: docker_push_latest
docker_push_latest:
	@docker login -u $(DOCKERHUB_USERNAME) -p $(DOCKERHUB_PASSWORD)
	docker push $(DOCKER_LATEST_TAG)
