#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

whereis gcc

ldd /usr/bin/gcc

# ***** postgresql *****

postgres_user=$(echo ${DATABASE_URL} | awk -F':' '{print $2}' | sed -e 's/\///g')
postgres_password=$(echo ${DATABASE_URL} | grep -o '/.\+@' | grep -o ':.\+' | sed -e 's/://' | sed -e 's/@//')
postgres_server=$(echo ${DATABASE_URL} | awk -F'@' '{print $2}' | awk -F':' '{print $1}')
postgres_dbname=$(echo ${DATABASE_URL} | awk -F'/' '{print $NF}')

echo ${postgres_user}
echo ${postgres_password}
echo ${postgres_server}
echo ${postgres_dbname}

export PGPASSWORD=${postgres_password}

# ***** utils *****

cd /tmp

mkdir -m 777 usr

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'usr.tar.bz2'
__HEREDOC__

if [ $(cat /tmp/sql_result.txt | grep -c '(1 row)') -eq 1 ]; then
  set +x
  echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/usr.tar.bz2.base64.txt
  set -x
  base64 -d /tmp/usr.tar.bz2.base64.txt > /tmp/usr.tar.bz2
  tar xf /tmp/usr.tar.bz2 -C /tmp/usr --strip=1
fi

# ***** env *****

export HOME2=${PWD}
export PATH="/app/bin:/tmp/usr/bin:${PATH}"
export LD_LIBRARY_PATH=/tmp/usr/lib

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

parallels=$(grep -c -e processor /proc/cpuinfo)

# ***** gcc *****

cd /tmp

time wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

tar xf gcc-7.3.0.tar.gz

cd gcc-7.3.0
mkdir -m 777 work
cd work

../configure --help
time ../configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc \
  --with-gmp==/tmp/usr --with-mpfr=/tmp/usr --with-mpc=/tmp/usr \
  --disable-multilib --enable-stage1-languages=c,c++ \
  target=x86_64-pc-linux-gnu \
  --disable-libjava --disable-libgo --disable-libgfortran --disable-objc --enable-languages=c,c++

time make -j${parallels}
make install

echo ${start_date}
date
