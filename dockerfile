FROM ubuntu:latest

MAINTAINER Alex Moiseenko <brainsam@yandex.ru>

COPY bootstrap.sh /root/

RUN /root/bootstrap.sh

ENTRYPOINT /opt/bacula/bin/bacula start

VOLUME /opt/bacula/etc/conf.d
VOLUME /opt/bacula/data

ENV DB_ADDRESS=127.0.0.1
ENV DB_USER=admin
ENV DB_PASS=password
ENV SMTP_HOST=localhost
ENV ADMIN_EMAIL=your@address.com

EXPOSE 9101 9102 9103
