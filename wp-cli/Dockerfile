FROM wordpress:cli-php7.4

USER root
RUN apk update && apk add perl && rm -rf /var/cache/apk/*

COPY wait-for-it.sh /usr/local/bin/wait-for-it
RUN chown www-data:www-data /usr/local/bin/wait-for-it && \
    chmod +x /usr/local/bin/wait-for-it

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown www-data:www-data /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

COPY yaml.sh /usr/local/bin/yaml.sh
RUN chown www-data:www-data /usr/local/bin/yaml.sh && \
    chmod +x /usr/local/bin/yaml.sh

RUN mkdir /backups && chown www-data:www-data /backups
USER www-data

WORKDIR /backups

RUN mkdir ~/.wp-cli && echo "path: /var/www/html" > ~/.wp-cli/config.yml
ENTRYPOINT ["entrypoint.sh"]
