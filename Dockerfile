FROM debian:latest

MAINTAINER Alex Moiseenko <brainsam@yandex.ru>

ENV DIR_NAME=bacula-dir
ENV DB_TYPE=mysql
ENV DB_NAME=bacula
ENV DB_USER=bacula
ENV DB_PASS=password
ENV ADMIN_EMAIL=your@address.com
ENV PATH /opt/bacula/etc:$PATH

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y wget gcc g++ make file git libmysqlclient-dev mysql-client sqlite3 bacula-common-pgsql libpq-dev

RUN mkdir /opt/bacula
RUN git clone http://git.bacula.org/bacula bacula 

RUN cd bacula/bacula && ./configure \
        --enable-smartalloc \
        --enable-batch-insert \
        --with-mysql \
		--with-sqlite \
		--with-postgresql \
        --sbindir=/opt/bacula/bin \
        --sysconfdir=/opt/bacula/etc \
        --with-pid-dir=/opt/bacula/working \
        --with-subsys-dir=/opt/bacula/working \
        --with-working-dir=/opt/bacula/working \
		--disable-build-stored \
		--with-x=NO && \
		
make && make install

# Add custom user config catalog
RUN mkdir /opt/bacula/etc/conf.d /opt/bacula/data
RUN echo "@|\"sh -c 'for f in /opt/bacula/etc/conf.d/*.conf ; do echo @${f} ; done'\"" >> /opt/bacula/etc/bacula-dir.conf

# Clean system from useless files
RUN apt-get remove wget gcc g++ make file git libmysqlclient-dev sqlite3 bacula-common-pgsql libpq-dev -y
RUN apt-get clean all
RUN rm -rf bacula

VOLUME /opt/bacula/etc/conf.d
VOLUME /opt/bacula/data

COPY entrypoint.sh /opt/bacula/
RUN chmod 755 /opt/bacula/entrypoint.sh

ENTRYPOINT ["/opt/bacula/entrypoint.sh"]

EXPOSE 9101 9102 9103
