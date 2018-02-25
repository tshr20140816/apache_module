#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

find / -name libisl.so.15 -print

mkdir -m 777 bin

cp -p /usr/bin/gcc ./bin/
cp -p /usr/lib/gcc/x86_64-linux-gnu/5/cc1 ./bin/
cp -p /usr/lib/gcc/x86_64-linux-gnu/5/cc1plus ./bin/

cp -p /usr/lib/x86_64-linux-gnu/libisl.so.15 ./lib/

echo ${start_date}
date

