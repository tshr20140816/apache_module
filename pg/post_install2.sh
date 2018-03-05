#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

export HOME2=${PWD}

cd www

git clone --depth 1 https://github.com/phppgadmin/phppgadmin.git

cd phppgadmin

cat classes/database/Connection.php

cp -f ./Connection.php classes/database/Connection.php
cp config.inc.php www/phppgadmin/conf/config.inc.php

echo ${start_date}
date
