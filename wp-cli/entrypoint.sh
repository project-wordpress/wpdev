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
    echo "Rewriting permalinks"
    wp rewrite structure '/%category%/%postname%/'
fi

declare -r CURRENT_DOMAIN=$(wp option get siteurl)

if ! [[ ${CURRENT_DOMAIN} == ${URL} ]]; then
    echo "Replacing ${CURRENT_DOMAIN} with ${URL} in database..."
    wp search-replace ${CURRENT_DOMAIN} ${URL}
fi


source yaml.sh

echo "Installing plugins..."
for VAR in $(parse_yaml /apps/config/wpdev.yaml _) ; do
    [[ ${VAR} == _plugins__* ]] && \
     echo "${VAR/_plugins__/}" > /dev/null && \
     PLUGIN=$(echo ${VAR} | perl -0777 -ne 'print "$&\n" if /(?<=\+=\(\").*?(?=\")/') && \
     echo "${PLUGIN}" && \
     wp plugin install --activate "${PLUGIN}"
done

echo "Installing themes..."
for VAR in $(parse_yaml /apps/config/wpdev.yaml _) ; do
    [[ ${VAR} == _themes__* ]] && \
     echo "${VAR/_themes__/}" > /dev/null && \
     THEME=$(echo ${VAR} | perl -0777 -ne 'print "$&\n" if /(?<=\+=\(\").*?(?=\")/') && \
     echo "${THEME}" && \
     wp theme install --activate "${THEME}"
done

echo "Deleting plugins"
wp plugin delete hello 2>&1
wp plugin delete akismet 2>&1

echo "Deleting themes"
wp theme delete twentynineteen 2>&1
wp theme delete twentyseventeen 2>&1
wp theme delete twentysixteen 2>&1


echo "Visit $(wp option get siteurl)/wp-login.php"
