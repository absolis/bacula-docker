# Docker image with Bacula Dir, Bacula SD and Bacula Mon

## Preface

## Prerequicites

For use this docker image you need:

* Mysql Server
* Config folder
* Backup storage folder

All of these components links by environment variables in the *docker run* command:

DB_ADDRESS - address of mysql server
DB_USER - username of account on mysql server, that have admin privileges on database "bacula"
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
    --env="DB_ADDRESS=127.0.0.1" \
    --env="DB_USER=username" \
    --env="DB_PASS=my_password" \
    --env="SMTP_HOST=localhost" \
    --env="ADMIN_EMAIL=your@address.com" \
    --volume=/path/to/config/folder:/opt/bacula/etc/ \
    --volume=/path/to/data/folder:/opt/bacula/data/ \
    brainsam/bacula-server

``` 
