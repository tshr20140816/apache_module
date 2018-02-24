#!/bin/bash

set -x

date
start_date=$(date)

printenv

cd /tmp

wget http://jnovy.fedorapeople.org/pxz/pxz-4.999.9beta.20091201git.tar.xz

tar xf pxz-4.999.9beta.20091201git.tar.xz

cd pxz-4.999.9beta

ls -lang

date
