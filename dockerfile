FROM ubuntu:latest

MAINTAINER Alex Moiseenko <brainsam@yandex.ru>

COPY bootstrap.sh /root/

RUN /root/bootstrap.sh

ENTRYPOINT /opt/bacula/bin/bacula start

VOLUME /opt/bacula/etc
VOLUME /opt/bacula/data

ENV \
  DB_ADDRESS=127.0.0.1 \
  DB_USER=admin \
  DB_PASS=password \
  SMTP_HOST=localhost \
  ADMIN_EMAIL=your@address.com

EXPOSE 9101 9102 9103
