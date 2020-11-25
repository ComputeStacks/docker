.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	docker build --no-cache -t cmptstks/woocommerce:php7.4-litespeed .

push: ## Tag latest and push to DockerHub
	docker tag cmptstks/woocommerce:php7.4-litespeed cmptstks/woocommerce:latest
	docker push cmptstks/woocommerce:php7.4-litespeed
	docker push cmptstks/woocommerce:latest