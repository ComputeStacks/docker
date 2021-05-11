.PHONY: help

help: ## Help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build all versions
	@docker build --no-cache -t cmptstks/mariadb-backup:10.2 10.2/
	@docker build --no-cache -t cmptstks/mariadb-backup:10.3 10.3/
	@docker build --no-cache -t cmptstks/mariadb-backup:10.4 10.4/
	@docker build --no-cache -t cmptstks/mariadb-backup:10.5 10.5/

push: ## Tag latest and push to @dockerHub
	@docker tag cmptstks/mariadb-backup:10.5 cmptstks/mariadb-backup:latest
	@docker push cmptstks/mariadb-backup:10.2
	@docker push cmptstks/mariadb-backup:10.3
	@docker push cmptstks/mariadb-backup:10.4
	@docker push cmptstks/mariadb-backup:10.5
	@docker push cmptstks/mariadb-backup:latest