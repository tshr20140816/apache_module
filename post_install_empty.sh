#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

cd www

gzip test.css
rm test.css

cd /tmp


echo ${start_date}
date
