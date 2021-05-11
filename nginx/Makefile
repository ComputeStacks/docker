.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	@docker build --no-cache -t cmptstks/nginx:stable .

push: ## Tag latest and push to DockerHub
	@docker tag cmptstks/nginx:stable cmptstks/nginx:latest
	@docker push cmptstks/nginx:stable
	@docker push cmptstks/nginx:latest