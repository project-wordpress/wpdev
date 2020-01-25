#### Wordpress Development Stack
[![Build Status](https://travis-ci.org/project-wordpress/wpdev.svg?branch=master)](https://travis-ci.org/project-wordpress/wpdev)


Local stack for developing [`wordpress`](https://wordpress.org/)

```bash
CONTAINER ID        NAME                  CPU %               MEM USAGE / LIMIT    MEM %               NET I/O             BLOCK I/O           PIDS

da0e07d3dcb3        nginx_1        0.00%               2.82MiB / 7.79GiB    0.04%               490kB / 1.01MB      0B / 0B             3

4875a813d4a0        wordpress_1    0.00%               12.78MiB / 7.79GiB   0.16%               603kB / 576kB       0B / 32.8kB         3

7f5cefd9d559        phpmyadmin_1   0.00%               9.32MiB / 7.79GiB    0.12%               210B / 0B           0B / 0B             6

16ce9c05cc74        mysql_1        0.25%               83.1MiB / 7.79GiB    1.04%               146kB / 611kB       0B / 58.2MB         41
```
### Dependencies:
* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)
* [wordpress](https://hub.docker.com/_/wordpress)
* [wp-cli](https://hub.docker.com/_/wordpress)
* [mysql](https://hub.docker.com/_/mysql/)
* [nginx](https://hub.docker.com/_/nginx)
* [nginx-proxy](https://github.com/jwilder/nginx-proxy)
* [phpmyadmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
* [make](https://www.gnu.org/software/make/)
* [travis](https://travis-ci.org/) for builds

### Requirements:
* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

### Usage:
* Edit [.env](./.env) file to your needs and run:
```bash
docker-compose up
```
* Wordpress will be automatically installed and after some time your site should be live at 
```bash
http://localhost:$WORDPRESS_PORT
```
* phpmyadmin will be live at
```bash
http://localhost:$PHPMYADMIN_PORT
```


## Info
* tests are parsing your site and checking if everything responds with status code `200`, to change that behaviour see [this file](./tests/python/crawl.py)
* static files are handled by `nginx`
* wp-cli will handle changing `SITE_URL`
* this stack can be easy deployed live using `make deploy`
# todo
* `localhost:9333/asdASDa/435/345/345/345` >> `homepage` why?
* modify wp-cli to allow custom setup (activating plugins etc.)
* allow crawl.py allowed rules to be specified in a file
