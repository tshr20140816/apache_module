#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

find / -name as -print
find / -name ld -print

mkdir -m 777 bin
mkdir -m 777 lib

cp -p /usr/bin/gcc ./bin/
cp -p /usr/lib/gcc/x86_64-linux-gnu/5/cc1 ./bin/
cp -p /usr/lib/gcc/x86_64-linux-gnu/5/cc1plus ./bin/

cp -p /usr/lib/x86_64-linux-gnu/libisl.so.15 ./lib/
cp -p /usr/lib/x86_64-linux-gnu/libmpfr.so.4 ./lib/

echo ${start_date}
date

