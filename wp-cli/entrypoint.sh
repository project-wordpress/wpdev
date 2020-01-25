#!/bin/bash
set -eu

declare -p WORDPRESS_HOST
wait-for-it ${WORDPRESS_HOST} -t 120

if [[ $1 == "deploy" ]]; then
    echo "Deploying...";
    declare -p DOMAIN_NAME
    URL="http://${DOMAIN_NAME}" #TODO https check

elif [[ $1 == "develop" ]]; then
    echo "Developing...";
    declare -p WORDPRESS_PORT
    [[ "${WORDPRESS_PORT}" == 80 ]] && \
    URL="http://localhost" || \
    URL="http://localhost:${WORDPRESS_PORT}"
else
    $@
    exit 0
fi

if $(wp core is-installed);
then
    echo "Wordpress is already installed..."
else
    declare -p WORDPRESS_TITLE >/dev/null
    declare -p WORDPRESS_LOGIN >/dev/null
    declare -p WORDPRESS_PASSWORD >/dev/null
    declare -p WORDPRESS_EMAIL >/dev/null
    echo "Installing wordpress..."
    wp core install \
        --url=${URL} \
        --title=${WORDPRESS_TITLE} \
        --admin_user=${WORDPRESS_LOGIN} \
        --admin_password=${WORDPRESS_PASSWORD} \
        --admin_email=${WORDPRESS_EMAIL} \
        --skip-email
fi

declare -r CURRENT_DOMAIN=$(wp option get siteurl)

if ! [[ ${CURRENT_DOMAIN} == ${URL} ]]; then
    echo "Replacing ${CURRENT_DOMAIN} with ${URL} in database..."
    wp search-replace ${CURRENT_DOMAIN} ${URL}
fi

echo "Visit $(wp option get siteurl)"
