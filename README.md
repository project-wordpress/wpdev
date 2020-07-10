#### Wordpress Development Stack
[![Build Status](https://travis-ci.org/project-wordpress/wpdev.svg?branch=master)](https://travis-ci.org/project-wordpress/wpdev)

Local stack for developing [`wordpress`](https://wordpress.org/)

There is a lot of files, but you may be interested only in few of them, don't worry!

### Usage:
* You can add plugins and themes that you want to be installed automatically in [wpdev.yaml](./var/config/wpdev.yaml) (for now only official plugins and themes can be installed this way using slug)
* Edit [.env](./.env) file to your needs (you may want to change ports if you are working on few project at a time )
* Default themes and plugins that are bundled with wordpress are deleted.

To start execute this command:
```bash
docker-compose up
```
* `wordpress` will be live at
```bash
http://localhost:$WORDPRESS_PORT
```
* `phpmyadmin` will be live at
```bash
http://localhost:$PHPMYADMIN_PORT
```
```bash
wordpress_1   | Complete! WordPress has been successfully copied to /var/www/html
wordpress_1   | [28-Jan-2020 13:05:22] NOTICE: fpm is running, pid 1
wordpress_1   | [28-Jan-2020 13:05:22] NOTICE: ready to handle connections
wp-cli_1      | wait-for-it: wordpress:9000 is available after 37 seconds
wp-cli_1      | Developing...
wp-cli_1      | declare -x WORDPRESS_PORT="9344"
wp-cli_1      | Installing wordpress...
mysql_1       | mbind: Operation not permitted
wp-cli_1      | Success: WordPress installed successfully.
wp-cli_1      | Installing plugins...
wp-cli_1      | Installing themes...
wp-cli_1      | Deleting plugins
wp-cli_1      | Deleted 'hello' plugin.
wp-cli_1      | Success: Deleted 1 of 1 plugins.
wp-cli_1      | Deleted 'akismet' plugin.
wp-cli_1      | Success: Deleted 1 of 1 plugins.
wp-cli_1      | Deleting themes
wp-cli_1      | Deleted 'twentynineteen' theme.
wp-cli_1      | Success: Deleted 1 of 1 themes.
wp-cli_1      | Deleted 'twentyseventeen' theme.
wp-cli_1      | Success: Deleted 1 of 1 themes.
wp-cli_1      | Deleted 'twentysixteen' theme.
wp-cli_1      | Success: Deleted 1 of 1 themes.
wp-cli_1      | Installing `theme`
wp-cli_1      | Unpacking the package...
wp-cli_1      | Installing the theme...
wp-cli_1      | Theme installed successfully.
wp-cli_1      | Success: Installed 1 of 1 themes.
wp-cli_1      | Activating all plugins...
wp-cli_1      | Success: No plugins installed.
wp-cli_1      | Activating `theme`
wp-cli_1      | Success: Switched to 'theme' theme.
wp-cli_1      | Rewriting permalinks
wp-cli_1      | Success: Rewrite structure set.
mysql_1       | mbind: Operation not permitted
wp-cli_1      | Success: Rewrite rules flushed.
wp-cli_1      | Visit http://localhost:9344/wp-login.php
```
## Info
* theres `run_tests.sh` or `.gitlab-ci.yml` that can be used to run your tests
* tests are parsing your site and checking if everything responds with status code `200`, to change that behaviour see [this file](./tests/python/crawl.py)
* static files are handled by `nginx`
* wp-cli will handle changing `SITE_URL` based on your `.env` settings

### Requirements:
* [docker](https://www.docker.com/)
* [docker-compose](https://docs.docker.com/compose/)

* to backup your database into `./var/backups` run:
```bash
make db-export
```
* to import your database into `./mysql/docker-entrypoint-initdb.d` run:
```bash
make copy-db
```
## Tests
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
* lower mysql and wordpress ram usage (currently 20MiB and 80MiB but after installing theme up to 300MiB and 400MiB?????)
* allow `crawl.py` allowed rules to be specified in a file
* create solid `nginx` configuration
* test file permissions and sensitive files
* mysql 8.0.18 gives `mbind: Operation not permitted`
