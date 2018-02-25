#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

whereis gcc

mkdir -m 777 -p /tmp/usr/bin/

cp -p /usr/bin/gcc /tmp/usr/bin/
cp -p /usr/bin/gcc ./

ldd /tmp/usr/bin/gcc

echo ${start_date}
date

