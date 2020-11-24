.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	docker build --no-cache -t cmptstks/whmcs:php7.3-litespeed litespeed/php7.3
	docker build --no-cache -t cmptstks/whmcs:php7.4-litespeed litespeed/php7.4

push: ## Tag latest and push to DockerHub
	docker tag cmptstks/whmcs:php7.4-litespeed cmptstks/whmcs:latest
	docker push cmptstks/whmcs:php7.3-litespeed
	docker push cmptstks/whmcs:php7.4-litespeed
	docker push cmptstks/whmcs:latest