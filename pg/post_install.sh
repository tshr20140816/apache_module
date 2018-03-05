#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

whereis python
python --version

cp /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 ./

export HOME2=${PWD}
export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

cd /tmp

wget https://github.com/GrahamDumpleton/mod_wsgi/archive/4.6.2.tar.gz

tar xf 4.6.2.tar.gz

cd mod_wsgi-4.6.2

./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc --enable-framework
time make -j2
make install

find / -name mod_wsgi.so -print

cp ${HOME2}/.heroku/php/libexec/mod_wsgi.so ${HOME2}/

cd ${HOME2}

wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.1/source/pgadmin4-2.1.tar.gz

tar xf pgadmin4-2.1.tar.gz
rm pgadmin4-2.1.tar.gz

cd pgadmin4-2.1

ls -Rlang

cd web

pip install flask
python setup.py

echo ${start_date}
date

