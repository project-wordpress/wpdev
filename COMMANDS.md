@madmath03 
With this command you can still connect to all stacks if you have consistent naming, just change `$NAME` 
````bash
NAME=wpdev && docker run --rm -it \
--volumes-from="${NAME}_wordpress_1" \
--network="${NAME}_default" \
-e WORDPRESS_HOST=wordpress:9000 \
-u 33 \
test \
\
/bin/bash
Success: WordPress is up to date.
````

Or if you have non-consistent naming place `.env` file in your `docker-compose.yaml` folder, `docker-compose` will read it automatically:
````bash
---------- 420 buk 345233  236 Jan 26 14:06 .env
---------- 420 buk 345233  124 Jan 26 14:06 docker-compose.yaml
````
````env
# .env
NETWORK_NAME=mynetwork
WORDPRESS_CONTAINER=mycontainer
````
````yaml
# docker-compose.yaml
networks:
  test:
    name: $NETWORK_NAME

services:

  wordpress:
    container_name: $WORDPRESS_CONTAINER
    networks:
      - test

  mysql:
    networks:
      - test
````
And then run:
```bash
source .env && \
docker run -it \
--volumes-from="${WORDPRESS_CONTAINER}" \
--network="${NETWORK_NAME}" \
wordpress:cli-php7.4 \
\
/bin/bash -c "wp core update"
```

To use `name` in `networks` you have  to use `docker-compose >= 3.4` 
Also, keep in mind:

> Values in the shell take precedence over those specified in the .env file. If you set TAG to a different value in your shell, the substitution in image uses that instead


* See https://docs.docker.com/v17.12/compose/environment-variables/#set-environment-variables-with-docker-compose-run
