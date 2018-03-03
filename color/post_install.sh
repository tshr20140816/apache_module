#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

cd /tmp

git clone --depth 1 --recursive https://github.com/kornelski/pngquant.git

cd pngquant
./configure --help
./configure --perfix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j2
make install

ls -Rlang /tmp/usr

echo ${start_date}
date
