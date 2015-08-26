FROM ubuntu:14.04

MAINTAINER Alex Moiseenko <brainsam@yandex.ru>

RUN \
apt-get update && apt-get install wget gcc g++ libmariadbd-dev make -y && \
wget http://sourceforge.net/projects/bacula/files/bacula/7.0.5/bacula-7.0.5.tar.gz && \
tar -zxvf bacula-7.0.5.tar.gz --directory /root/ && rm bacula-7.0.5.tar.gz &&\
cd /root/bacula-7.0.5 && \

./configure \
        --enable-smartalloc \
        --enable-batch-insert \
        --with-mysql \
        --sbindir=/opt/bacula/bin \
        --sysconfdir=/opt/bacula/etc \
        --with-pid-dir=/opt/bacula/working \
        --with-subsys-dir=/opt/bacula/working \
        --with-working-dir=/opt/bacula/working \
        --with-job-email=your@address.com \
        --with-smtp-host=localhost && \

make && make install && \

apt-get remove wget gcc g++ libmariadbd-dev make -y && \
apt-get clean all

COPY bootstrap.sh /root

ENTRYPOINT /opt/bacula/bin/bacula

CMD start

VOLUME /opt/bacula/etc
VOLUME /data

ENV \
  DB_ADDRESS=127.0.0.1 \
  DB_USER=admin \
  DB_PASS=password \
  SMTP_HOST=localhost \
  ADMIN_EMAIL=your@address.com

EXPOSE 9101 9102 9103
