#!/bin/bash
set -eux
source ../../.env

declare -r STATIC_PATH="/wp-includes/js/jquery/jquery.js"

wait-for-url() {
    echo "Testing $1"
    timeout -s TERM 45 bash -c \
    'while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
    do echo "Waiting for ${0}" && sleep 2;\
    done' ${1}
    echo "OK!"
    curl -I $1
}

if [[ $1 == "develop" ]];
then
    declare -p WORDPRESS_PORT
    declare -r HOST="localhost:${WORDPRESS_PORT}"
fi

if [[ $1 == "deploy" ]];
then
    declare -p DOMAIN_NAME
    declare -r HOST="${DOMAIN_NAME}"
fi

wait-for-url http://${HOST}
wait-for-url http://${HOST}${STATIC_PATH}

echo http://${HOST}
