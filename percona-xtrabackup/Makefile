.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	@docker build --no-cache -t cmptstks/xtrabackup:2.4 2.4/
	@docker build --no-cache -t cmptstks/xtrabackup:8.0 8.0/

push: ## Tag latest and push to @dockerHub
	@docker tag cmptstks/xtrabackup:8.0 cmptstks/xtrabackup:latest
	@docker push cmptstks/xtrabackup:2.4
	@docker push cmptstks/xtrabackup:8.0
	@docker push cmptstks/mariadb-backup:latest