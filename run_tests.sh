#!/bin/bash
source .env
set -euxo pipefail

# Run this test via "make tests"
# This test assumes that you have
# DNS entry "127.0.0.1 $DOMAIN_NAME"

declare -r DEVELOP="docker-compose -f docker-compose.yaml -f docker-compose.override.yaml"
declare -r ALIVE="docker-compose -f docker-compose.yaml -f docker-compose.deploy.yaml"

${DEVELOP} build
${ALIVE} build


function test_development() {
    ${DEVELOP} up --exit-code-from=wp-cli
    ${DEVELOP} up --detach
    make folder=./tests/python file=connect test args="localhost $WORDPRESS_PORT / 200 " || (${DEVELOP} logs && exit 1)
    make folder=./tests/python file=connect test args="localhost $WORDPRESS_PORT /wp-includes/js/jquery/jquery.js 200" || (${DEVELOP} logs && exit 1)
    make folder=./tests/python file=crawl test args="http://localhost:$WORDPRESS_PORT"
}

function test_alive() {
    ${ALIVE} up --exit-code-from=wp-cli
    ${ALIVE} up --detach
    make folder=./tests/python file=connect test args="$DOMAIN_NAME 80 / 200 " || (${ALIVE} logs && exit 1)
    make folder=./tests/python file=connect test args="$DOMAIN_NAME 80 /wp-includes/js/jquery/jquery.js 200" || (${ALIVE} logs && exit 1)
    make folder=./tests/python file=crawl test args="http://$DOMAIN_NAME"
}

test_development
test_alive
test_development

${ALIVE} down -v ||
${DEVELOP} down -v ||

test_alive
test_development

docker stats --no-stream
docker ps

${ALIVE} down -v ||
${DEVELOP} down -v ||

exit 0
