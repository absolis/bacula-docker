#!/bin/bash

# Skip if bacula has already installed 
if [ -f /opt/bacula/bacula ]; then
  exit
fi

echo "I'm here"

# Install several programms for Bacula deploy
sudo apt-get update
sudo apt-get -y install wget gcc g++ libmariadbd-dev make

# /opt/bacula - will be a program directory
mkdir /opt/bacula

# Downloading and untar bacula package
git clone http://git.bacula.org/bacula bacula \

cd bacula && \

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
make && make install && \

# Clean system from useless files
apt-get remove wget gcc g++ libmariadbd-dev make -y && \
apt-get clean all

 
