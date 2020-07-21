.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	docker build --no-cache -t cmptstks/alpine-passenger:ruby2.6 passenger-alpine/ruby2.6
	docker build --no-cache -t cmptstks/alpine-passenger:ruby2.7 passenger-alpine/ruby2.7

push: ## Tag latest and push to DockerHub
	docker tag cmptstks/alpine-passenger:ruby2.7 cmptstks/alpine-passenger:latest
	docker push cmptstks/alpine-passenger:ruby2.6
	docker push cmptstks/alpine-passenger:ruby2.7
	docker push cmptstks/alpine-passenger:latest