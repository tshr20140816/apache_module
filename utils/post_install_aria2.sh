#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

gcc --version
pkg-config --help

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

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
DELETE
  FROM t_files
 WHERE file_name IN ('usr_gettext_aria2.tar.bz2', 'make_aria2_log.txt')
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
 WHERE file_name = 'usr_gettext.tar.bz2'
__HEREDOC__

# ***** /tmp/usr *****

cd /tmp

mkdir -m 777 usr

set +x
echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/usr.tar.bz2.base64.txt
set -x
base64 -d /tmp/usr.tar.bz2.base64.txt > /tmp/usr.tar.bz2
tar xf /tmp/usr.tar.bz2 -C /tmp/usr --strip=1

cd usr

ls -Rlang

# ***** ccache *****

cd /tmp

wget https://www.samba.org/ftp/ccache/ccache-3.3.4.tar.gz
tar xf ccache-3.3.4.tar.gz
cd ccache-3.3.4
./configure --help
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j$(grep -c -e processor /proc/cpuinfo)
make install

cd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++

mkdir -m 777 /tmp/ccache
export CCACHE_DIR=/tmp/ccache

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'ccache_aria2_cache.tar.bz2'
__HEREDOC__

if [ $(cat /tmp/sql_result.txt | grep -c '(1 row)') -eq 1 ]; then
  set +x
  echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/ccache_cache.tar.bz2.base64.txt
  set -x
  base64 -d /tmp/ccache_cache.tar.bz2.base64.txt > /tmp/ccache_cache.tar.bz2
  tar xf /tmp/ccache_cache.tar.bz2 -C /tmp/ccache --strip=1
fi

ccache -s
ccache -z

# ***** aria2 *****

cd /tmp

wget https://github.com/aria2/aria2/archive/release-1.33.1.tar.gz

tar xf release-1.33.1.tar.gz

cd aria2-release-1.33.1

autoreconf -i

./configure --help
# ./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc ARIA2_STATIC=yes
./configure --prefix=/tmp/usr --mandir=/tmp/man --docdir=/tmp/doc
time make -j2 | tee -a /tmp/make_aria2_log.txt
make install

# ***** tar *****

cd /tmp
time tar -jcf usr_gettext_aria2.tar.bz2 usr

base64 -w 0 usr_gettext_aria2.tar.bz2 > usr_gettext_aria2.tar.bz2.base64.txt

set +x
base64_text=$(cat /tmp/usr_gettext_aria2.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('usr_gettext_aria2.tar.bz2', '${base64_text}');
__HEREDOC__
set -x

cd /tmp
base64 -w 0 make_aria2_log.txt > make_aria2_log.base64.txt

set +x
base64_text=$(cat /tmp/make_aria2_log.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('make_aria2_log.txt', '${base64_text}');
__HEREDOC__
set -x

cd /tmp
time tar -jcf ccache_cache.tar.bz2 ccache
base64 -w 0 ccache_cache.tar.bz2 > ccache_cache.tar.bz2.base64.txt

ls -lang

set +x
base64_text=$(cat /tmp/ccache_cache.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('ccache_aria2_cache.tar.bz2', '${base64_text}');
__HEREDOC__
set -x

ls -Rlang /tmp/usr

echo ${start_date}
date
