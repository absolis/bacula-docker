#!/bin/bash

# Skip if bacula has already installed 
if [-f /opt/bacula/bacula]; then
  exit
fi

# Install several programms for Bacula deploy
sudo apt-get update
sudo apt-get -y install wget gcc g++ libmariadbd-dev make

# /opt/bacula - will be a program directory
mkdir /opt/bacula

# Downloading and untar bacula package
wget http://sourceforge.net/projects/bacula/files/bacula/7.0.5/bacula-7.0.5.tar.gz
tar -zxvf bacula-7.0.5.tar.gz --directory /root/ && rm bacula-7.0.5.tar.gz &&\
cd /root/bacula-7.0.5 && \

# Compiling from sources
./configure \
        --enable-smartalloc \
        --enable-batch-insert \
        --with-mysql \
        --sbindir=/opt/bacula/bin \
        --sysconfdir=/opt/bacula/etc \
        --with-pid-dir=/opt/bacula/working \
        --with-subsys-dir=/opt/bacula/working \
        --with-working-dir=/opt/bacula/working \
        --with-job-email="$ADMIN_EMAIL" \
        --with-smtp-host="$SMTP_HOST" && \
make && make install && \

# Clean system from useless files
apt-get remove wget gcc g++ libmariadbd-dev make -y && \
apt-get clean all

 
