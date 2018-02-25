#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

whereis gcc

cp -p /usr/bin/gcc /tmp/usr/bin/

ldd /tmp/usr/bin/gcc

echo ${start_date}
date

