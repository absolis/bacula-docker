#!/bin/bash

# Skip if bacula has already installed 
if [ -f /opt/bacula/bacula ]; then
  exit
fi

cd bacula && \

sed -i 's/^\s*dbname=.*$//' bacula/src/dird/bacula-dir.conf.in

mkdir /opt/bacula

# Compiling from sources
./configure \
        --enable-smartalloc \
        --enable-batch-insert \
        --with-mysql \
		--with-db-name=${DB_NAME:-bacula} \
		--with-db-user=${DB_USER:-bacula} \
		--with-db-password=${DB_PASS:-bacula} \
		--with-db-port=${DB_PORT:-null} \
        --sbindir=/opt/bacula/bin \
        --sysconfdir=/opt/bacula/etc \
        --with-pid-dir=/opt/bacula/working \
        --with-subsys-dir=/opt/bacula/working \
        --with-working-dir=/opt/bacula/working \
make && make install && \

# Add custom user config catalog
mkdir /opt/bacula/etc/conf.d
echo "@|\"sh -c 'for f in /opt/bacula/etc/*.conf ; do echo @${f} ; done'\"" >> /opt/bacula/etc/bacula-dir.conf

# Clean system from useless files
apt-get remove wget gcc g++ libmariadbd-dev make -y && \
apt-get clean all


 
