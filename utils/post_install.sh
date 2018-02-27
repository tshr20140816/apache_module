#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version

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

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_name
      ,length(file_base64_text)
  FROM t_files
 ORDER BY file_name
__HEREDOC__
cat /tmp/sql_result.txt

# ***** env *****

export PATH="/tmp/usr/bin:${PATH}"
export LD_LIBRARY_PATH=/tmp/usr/lib

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'usr_gettext_aria2.tar.bz2'
__HEREDOC__

# ***** /tmp/usr *****

cd /tmp

mkdir -m 777 usr

set +x
echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/usr.tar.bz2.base64.txt
set -x
base64 -d /tmp/usr.tar.bz2.base64.txt > /tmp/usr.tar.bz2
tar xf /tmp/usr.tar.bz2 -C /tmp/usr --strip=1

ls -Rlang /tmp/usr

cd /tmp
wget http://zlib.net/pigz/pigz-2.4.tar.gz

tar xf pigz-2.4.tar.gz
cd pigz-2.4
make -j2
cp -p pigz unpigz /tmp/usr/bin/

cd /tmp
time aria2c -x4 http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz
rm gcc-7.3.0.tar.gz
time wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz

#time tar xf cmake-3.10.2-Linux-x86_64.tar.gz
#rm -rf cmake-3.10.2-Linux-x86_64
#time pigz -d cmake-3.10.2-Linux-x86_64.tar.gz
#time tar xf cmake-3.10.2-Linux-x86_64.tar

ls -lang

tar --help

echo ${start_date}
date
