#!/bin/bash

set -x

date
start_date=$(date)

printenv

cd /tmp

wget http://zlib.net/pigz/pigz-2.4.tar.gz

tar xf pigz-2.4.tar.gz

cd pigz-2.4

ls -lang
#./configure --help
#./configure --prefix=/tmp/usr

date
