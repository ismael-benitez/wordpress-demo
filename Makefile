#!make
.DEFAULT_GOAL := help

t ?= 20
CONFIG_ENVIRONMENT ?= ./config/local.env
ifneq (,$(wildcard $(CONFIG_ENVIRONMENT)))
    include $(CONFIG_ENVIRONMENT)
    export
	DOCKER_COMPOSE = docker-compose --env-file $(CONFIG_ENVIRONMENT)
endif

.prerequisites:
	@docker --version >/dev/null 2>&1 || (echo "ERROR: docker is required: https://docs.docker.com/get-docker/"; exit 1)
	@docker-compose --version >/dev/null 2>&1 || (echo "ERROR: docker-compose is required: https://docs.docker.com/compose/install/"; exit 1)

setup: | .prerequisites ## Setup the app
	[ -f ./docker-compose.yml ] || cp docker-compose.dist.yml docker-compose.yml
	$(DOCKER_COMPOSE) build
	$(DOCKER_COMPOSE) up -d
	sleep 10
	$(DOCKER_COMPOSE) exec wordpress demo 

start: ## Spin up the wordpress & mysql containers
	[ -f ./docker-compose.yml ] || make setup
	$(DOCKER_COMPOSE) up -d --no-recreate $(c)
	make open DOMAIN=$(DOMAIN)/wp-admin/

stop: ## Turn off your local environment
	[ -f ./docker-compose.yml ] || (echo "ERROR: you don't have any running container."; exit 1)
	$(DOCKER_COMPOSE) down $(c)

clean: ## Stop and clear your local environment
	[ -f ./docker-compose.yml ] || (echo "ERROR: you don't have any running container."; exit 1)
	$(DOCKER_COMPOSE) down --volumes
	rm docker-compose.yml

clear: clean

.PHONY: admin
admin: | start ## Open the admin site in your default browser
	@echo "Opening in your browser: $(DOMAIN)"
ifdef WSLENV
	cmd.exe /C start $(DOMAIN)
else
	UNAME := $(shell uname)
	ifeq ($(UNAME), Windows)
		start $(DOMAIN)
	endif
	ifeq ($(UNAME), Darwin)
		open $(DOMAIN)
	endif
	ifeq ($(UNAME), Linux)
		xdg-open $(DOMAIN)
	endif
endif

.PHONY: bash
bash: | start ## Open a bash terminal in the wordpress container
	$(DOCKER_COMPOSE) exec wordpress bash

.PHONY: logs
logs: | start ## Show the logs of your local `wordpress`  or `db` container
	$(DOCKER_COMPOSE) logs --tail=$(t) $(c)

.PHONY: mysql
mysql: | start ## Open a mysql shell
	@docker-compose exec db mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE)

.PHONY: help
help: ## Display this help message
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
