.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	docker build --no-cache -t cmptstks/php:7.3-apache apache/7.3-apache
	docker build --no-cache -t cmptstks/php:7.3-litespeed open-litespeed/7.3-litespeed
	docker build --no-cache -t cmptstks/php:7.4-litespeed open-litespeed/7.4-litespeed

push: ## Tag latest and push to DockerHub
	docker tag cmptstks/php:7.4-litespeed cmptstks/php:latest
	docker push cmptstks/php:7.3-apache
	docker push cmptstks/php:7.3-litespeed
	docker push cmptstks/php:7.4-litespeed
	docker push cmptstks/php:latest