#!/bin/bash

set -x

date
start_date=$(date)

cd /tmp

wget https://tukaani.org/xz/xz-5.2.3.tar.gz

tar xf xz-5.2.3.tar.gz

cd xz-5.2.3

ls -Rlang 

date
