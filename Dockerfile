FROM debian:latest

MAINTAINER Alex Moiseenko <brainsam@yandex.ru>

COPY bootstrap.sh /root/

ENV DB_HOST=127.0.0.1
ENV DB_USER=admin
ENV DB_PASS=password
ENV SMTP_HOST=localhost
ENV ADMIN_EMAIL=your@address.com
ENV PATH /opt/bacula/bin:$PATH

RUN apt-get update && apt-get install -y wget gcc g++ libmariadbd-dev make git
RUN git clone http://git.bacula.org/bacula bacula 

RUN mkdir /opt/bacula

RUN ./configure \
        --enable-smartalloc \
        --enable-batch-insert \
        --with-mysql \
		--with-db-port=3306 \
        --sbindir=/opt/bacula/bin \
        --sysconfdir=/opt/bacula/etc \
        --with-pid-dir=/opt/bacula/working \
        --with-subsys-dir=/opt/bacula/working \
        --with-working-dir=/opt/bacula/working \
RUN make && make install &&

# Add custom user config catalog
RUN mkdir /opt/bacula/etc/conf.d
RUN echo "@|\"sh -c 'for f in /opt/bacula/etc/conf.d/*.conf ; do echo @${f} ; done'\"" >> /opt/bacula/etc/bacula-dir.conf

RUN sed -i 's/^\s*dbname=.*$/dbname = ${DB_NAME:-bacula}\n
user = ${DB_USER:-bacula}\n
password = "${DB_PASS:-bacula}\n"
DB Address = ${DB_HOST:-localhost}\n
DB Port = ${DB_PORT:-null}/' /opt/bacula/etc/bacula-dir.conf

# Clean system from useless files
RUN apt-get remove wget gcc g++ libmariadbd-dev make -y
RUN apt-get clean all

VOLUME /opt/bacula/etc/conf.d
VOLUME /opt/bacula/data

CMD bacula start

EXPOSE 9101 9102 9103