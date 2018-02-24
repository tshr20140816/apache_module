#!/bin/bash

set -x

date
start_date=$(date)

cd /tmp

git clone --depth 1 https://github.com/xz-mirror/xz

cd xz
./autogen.sh

ls -lang

date
