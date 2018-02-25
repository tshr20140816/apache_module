#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

find / -name cc1 -print
find / -name cc1plus -print
whereis cc1

mkdir -m 777 bin

cp -p /usr/bin/gcc ./bin/
cp -p /bin/uname ./bin/
cp -p /usr/bin/arch ./bin/
cp -p /usr/lib/gcc/x86_64-linux-gnu/5/cc1 ./bin/
cp -p /usr/lib/gcc/x86_64-linux-gnu/5/cc1plus ./bin/

echo ${start_date}
date

