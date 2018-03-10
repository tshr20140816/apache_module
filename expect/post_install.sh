#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

export HOME2=${PWD}
export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

# ***** tcl *****

cd /tmp

wget https://prdownloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz
tar xf tcl8.6.8-src.tar.gz
cd tcl*
pwd
cd unix
ls -lang
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man
time make -j2
make install

# ***** expect *****

cd /tmp

wget https://jaist.dl.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz

tar xf expect5.45.4.tar.gz

cd expect5.45.4
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j2
make install

# ***** heroku cli *****

cd /tmp

wget https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz -O heroku.tar.gz

mkdir -m 777 ${HOME2}/heroku-cli

tar xf heroku.tar.gz -C ${HOME2}/heroku-cli --strip=1


# *****

cd /tmp/usr

ls -Rlang

ldd ./bin/expect

echo ${start_date}
date
