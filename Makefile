include .env
DEV				=docker-compose -f docker-compose.yaml -f docker-compose.override.yaml
DEPLOY			=docker-compose -f docker-compose.yaml -f docker-compose.deploy.yaml

WP-CLI			=${DEV} run wp-cli
MYSQLAUTH		=caching_sha2_password
DB-EXPORT		=${WP-CLI} wp db export --default-auth=${MYSQLAUTH} --porcelain

.PHONY: build
build:
	${DEV} build

.PHONY: up
up: build
	${DEV} up

.PHONY: down
down:
	${DEV} down

.PHONY: reset
reset: down up

.PHONY: buildup
buildup: build up

.PHONY: deploy
deploy: build
	-${DEV} down
	${DEPLOY} up --detach

.PHONY: clear
clear:
	-${DEV} down -v
	-${DEPLOY} down -v
# ======================================================== $

.PHONY: db-export
db-export:
	@${WP-CLI} wp db export ${MYSQLAUTH} --porcelain

.PHONY: copy-db
wtf:
	BACKUP_FILE=$(shell make db-export | tail -1);\
	cp ./var/backups/$$BACKUP_FILE ./mysql/docker-entrypoint-initdb.d

#file=connect
#folder=./tests/python
#args="localhost ${WORDPRESS_PORT} / 200"
.PHONY: test
test:	## make file=connect folder=./tests/python test args="localhost 80 / 200"
	docker run --rm --network=host $$(docker build -q --build-arg FILE=$(file).py $(folder)) $(args)

# todo before deployment only local testing script should be run
.PHONY: tests
tests:
	./run_tests.sh

.PHONY: crawl-local
crawl-local:
	make folder=./tests/python file=crawl test args="http://localhost:${WORDPRESS_PORT}"

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
