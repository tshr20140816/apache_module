#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

cd /tmp

wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.1/source/pgadmin4-2.1.tar.gz

tar xf pgadmin4-2.1.tar.gz

cd pgadmin4-2.1

ls -lang


echo ${start_date}
date

