#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

whereis uname
whereis arch

mkdir -m 777 bin

cp -p /usr/bin/gcc ./bin/
cp -p /bin/uname ./bin/
cp -p /usr/bin/arch ./bin/

echo ${start_date}
date

