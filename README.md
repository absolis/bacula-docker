# Docker image with Bacula Dir, Bacula SD and Bacula Mon

## Preface

## Prerequicites

To use bacula-docker container image you need:

* Mysql Server
* Config folder
* Backup storage folder

All of these components links by environment variables in the *docker run* command:

DIR_NAME - is set to "bacula-dir" by default, changes the Director name parameter
DB_TYPE - mysql (DEFAULT), postgresql or sqlite
DB_HOST - address of mysql server
DB_USER - username of account on mysql server, that have admin privileges on database "bacula"
DB_PORT - default null
DB_PASS - password for DB_USER accout
SMTP_HOST - address of smtp server
ADMIN_EMAIL - email address to send reports from bacula server




## Usage

```
docker run \
    -d \
    --name bacula-server \
    -p 9101:9101 \
    -p 9102:9102 \
    -p 9103:9103 \
	--env="DB_TYPE=mysql" \
    --env="DB_HOST=127.0.0.1" \
    --env="DB_USER=username" \
    --env="DB_PASS=my_password" \
    --env="SMTP_HOST=localhost" \
    --env="ADMIN_EMAIL=your@address.com" \
    --volume=/path/to/config/directory:/opt/bacula/etc/conf.d/ \
    --volume=/path/to/data/directory:/opt/bacula/data/ \
    brainsam/bacula-server

``` 
