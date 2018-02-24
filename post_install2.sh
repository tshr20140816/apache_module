#!/bin/bash

set -x

date
start_date=$(date)

cd /tmp

wget https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz

tar xf pbzip2-1.1.13.tar.gz

cd pbzip2-1.1.13

cat Makefile

time make -j2

ls -Rlang 

date
