#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version
pkg-config --help

# ***** postgresql *****

postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

echo ${postgres_user}
echo ${postgres_password}
echo ${postgres_server}
echo ${postgres_dbname}

export PGPASSWORD=${postgres_password}

# *****

cd /tmp

wget https://github.com/aria2/aria2/archive/release-1.33.1.tar.gz

tar xf release-1.33.1.tar.gz

cd aria2-release-1.33.1

./configure --help

ls -lang

echo ${start_date}
date
