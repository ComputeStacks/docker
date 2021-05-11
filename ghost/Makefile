.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	@docker build --no-cache -t cmptstks/ghost:4 .

push: ## Tag latest and push to DockerHub
	@docker tag cmptstks/ghost:4 cmptstks/ghost:latest
	@docker push cmptstks/ghost:4
	@docker push cmptstks/ghost:latest