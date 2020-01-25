#### Wordpress Development Stack
[![Build Status](https://travis-ci.org/project-wordpress/wpdev.svg?branch=master)](https://travis-ci.org/project-wordpress/wpdev)

Local stack for developing [`wordpress`](https://wordpress.org/)

Future goal of this project is to bring painless developing experience alongside production ready containers ready to be deploy to plain `docker` or `kubernetes` via `CI/CD` pipelines.
```bash
CONTAINER ID        NAME                  CPU %               MEM USAGE / LIMIT    MEM %               NET I/O             BLOCK I/O           PIDS

da0e07d3dcb3        nginx_1        0.00%               2.82MiB / 7.79GiB    0.04%               490kB / 1.01MB      0B / 0B             3

4875a813d4a0        wordpress_1    0.00%               12.78MiB / 7.79GiB   0.16%               603kB / 576kB       0B / 32.8kB         3

7f5cefd9d559        phpmyadmin_1   0.00%               9.32MiB / 7.79GiB    0.12%               210B / 0B           0B / 0B             6

16ce9c05cc74        mysql_1        0.25%               83.1MiB / 7.79GiB    1.04%               146kB / 611kB       0B / 58.2MB         41
```
## Info
* please get involved if you can
* tests are parsing your site and checking if everything responds with status code `200`, to change that behaviour see [this file](./tests/python/crawl.py)
* static files are handled by `nginx`
* wp-cli will handle changing `SITE_URL` based on your `.env` settings
* this stack can be easy deployed live using `make deploy`

### Requirements:
* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

### Usage:
* Edit [.env](./.env) file to your needs and run:
```bash
docker-compose up
```
* Wordpress will be automatically installed your site should be live at `
http://localhost:$WORDPRESS_PORT`
```bash
wordpress_1   | Complete! WordPress has been successfully copied to /var/www/html
wordpress_1   | [25-Jan-2020 22:46:56] NOTICE: fpm is running, pid 1
wordpress_1   | [25-Jan-2020 22:46:56] NOTICE: ready to handle connections
wp-cli_1      | wait-for-it: wordpress:9000 is available after 35 seconds
wp-cli_1      | Developing...
wp-cli_1      | Installing wordpress...
wp-cli_1      | Success: WordPress installed successfully.
wp-cli_1      | Visit http://localhost:9344
wpdev_wp-cli_1 exited with code 0
```
* phpmyadmin will be live at
```bash
http://localhost:$PHPMYADMIN_PORT
```
* to backup your database into `./var/backups` run:
```bash
make db-export
```
* to import your database into `./mysql/docker-entrypoint-initdb.d` run:
```bash
make copy-db
```
## Tests
* while running `make tests` or directly calling `run_tests.sh` live deployment will be tested too, it means that your host should resolve `$DOMAIN_NAME` from `.env` file
* to run a simle crawling test checking for status code 200 on your local development run
    ```bash
    make crawl-local
    ```
  ```bash
    PARSED
    {
        "http://localhost:9344/?feed=rss2": 200,
        "http://localhost:9344/?feed=comments-rss2": 200,
        "http://localhost:9344/wp-includes/css/dist/block-library/style.min.css?ver=5.3.2": 200,
        "http://localhost:9344/wp-content/themes/twentytwenty/style.css?ver=1.1": 200,
        "http://localhost:9344/wp-content/themes/twentytwenty/print.css?ver=1.1": 200,
        "http://localhost:9344/wp-content/themes/twentytwenty/assets/js/index.js?ver=1.1": 200,
        "http://localhost:9344/index.php?rest_route=/": 200,
        "http://localhost:9344/xmlrpc.php?rsd": 200,
        "http://localhost:9344/wp-includes/wlwmanifest.xml": 200,
        "http://localhost:9344/": 200,
        "http://localhost:9344/?page_id=2": 200,
        "http://localhost:9344/?cat=1": 200,
        "http://localhost:9344/?p=1": 200,
        "http://localhost:9344/?author=1": 200,
        "http://localhost:9344/?p=1#comments": 200,
        "http://localhost:9344/?p=1#comment-1": 200,
        "http://localhost:9344/?m=202001": 200,
        "http://localhost:9344/wp-login.php": 200,
        "http://localhost:9344/wp-includes/js/wp-embed.min.js?ver=5.3.2": 200,
        "http://localhost:9344/xmlrpc.php": 405,
        "http://localhost:9344/?feed=rss2&#038;page_id=2": 200,
        "http://localhost:9344/?p=2": 200,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fpage_id%3D2": 400,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fpage_id%3D2&#038;format=xml": 400,
        "http://localhost:9344/wp-admin/": 200,
        "http://localhost:9344/?feed=rss2&#038;cat=1": 200,
        "http://localhost:9344/?feed=rss2&#038;p=1": 200,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fp%3D1": 400,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fp%3D1&#038;format=xml": 400,
        "http://localhost:9344/?p=1&#038;replytocom=1#respond": 200,
        "http://localhost:9344/wp-comments-post.php": 405,
        "http://localhost:9344/wp-includes/js/comment-reply.min.js?ver=5.3.2": 200,
        "http://localhost:9344/?feed=rss2&#038;author=1": 200,
        "http://localhost:9344/wp-includes/css/dashicons.min.css?ver=5.3.2": 200,
        "http://localhost:9344/wp-includes/css/buttons.min.css?ver=5.3.2": 200,
        "http://localhost:9344/wp-admin/css/forms.min.css?ver=5.3.2": 200,
        "http://localhost:9344/wp-admin/css/l10n.min.css?ver=5.3.2": 200,
        "http://localhost:9344/wp-admin/css/login.min.css?ver=5.3.2": 200,
        "http://localhost:9344/wp-login.php?action=lostpassword": 200,
        "http://localhost:9344/wp-includes/js/jquery/jquery.js?ver=1.12.4-wp": 200,
        "http://localhost:9344/wp-includes/js/jquery/jquery-migrate.min.js?ver=1.4.1": 200,
        "http://localhost:9344/wp-includes/js/zxcvbn-async.min.js?ver=1.0": 200,
        "http://localhost:9344/wp-admin/js/password-strength-meter.min.js?ver=5.3.2": 200,
        "http://localhost:9344/wp-includes/js/underscore.min.js?ver=1.8.3": 200,
        "http://localhost:9344/wp-includes/js/wp-util.min.js?ver=5.3.2": 200,
        "http://localhost:9344/wp-admin/js/user-profile.min.js?ver=5.3.2": 200
    }
    ERRORS_ALLOWED
    {
        "http://localhost:9344/xmlrpc.php": 405,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fpage_id%3D2": 400,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fpage_id%3D2&#038;format=xml": 400,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fp%3D1": 400,
        "http://localhost:9344/index.php?rest_route=%2Foembed%2F1.0%2Fembed&#038;url=http%3A%2F%2Flocalhost%3A9344%2F%3Fp%3D1&#038;format=xml": 400,
        "http://localhost:9344/wp-comments-post.php": 405
    }
    ERRORS_BODY
    {}
    ERRORS
    {}

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

# todo & needs fixing
* design db migration schemas and production database separation
* make http benchmarking
* lower mysql ram usage (currently 80MiB)
* urls like `localhost:9333/asdASDa/435/345/345/345` redirect to `homepage` why?
* modify `wp-cli` to allow custom setup (activating plugins etc.)
* allow `crawl.py` allowed rules to be specified in a file
* create solid `nginx` configuration
* test file permissions and sensitive files
* mysql 8.0.18 gives `mbind: Operation not permitted`
