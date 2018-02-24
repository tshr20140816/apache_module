#!/bin/bash

set -x

date
start_date=$(date)

cd /tmp

wget https://sourceforge.net/projects/lzmautils/files/xz-5.2.3.tar.bz2/download -O xz-5.2.3.tar.gz

tar xf xz-5.2.3.tar.gz

cd xz-5.2.3

ls -Rlang 

date
