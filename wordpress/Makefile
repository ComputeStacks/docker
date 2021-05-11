.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	@docker build --no-cache -t cmptstks/wordpress:php7.3-litespeed php7.3-litespeed
	@docker build --no-cache -t cmptstks/wordpress:php7.4-litespeed php7.4-litespeed

push: ## Tag latest and push to DockerHub
	@docker tag cmptstks/wordpress:php7.4-litespeed cmptstks/wordpress:latest
	@docker push cmptstks/wordpress:php7.3-litespeed
	@docker push cmptstks/wordpress:php7.4-litespeed
	@docker push cmptstks/wordpress:latest