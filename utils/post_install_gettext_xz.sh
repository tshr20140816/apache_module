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

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

# ***** gettext *****

cd /tmp

wget http://ftp.gnu.org/pub/gnu/gettext/gettext-latest.tar.gz

tar xf gettext-latest.tar.gz
cd gettext*
./configure --help
./configure --prefix=/tmp/usr --disable-java --disable-native-java --without-emacs \
  --mandir=/tmp/man --docdir=/tmp/doc
make -j2
make install

# ***** xz *****

cd /tmp

git clone --depth 1 https://github.com/xz-mirror/xz

cd xz
./autogen.sh

./configure --help
./configure --prefix=/tmp/usr \
  --mandir=/tmp/man --docdir=/tmp/doc
time make -j2
make install

# ***** tar *****

cd /tmp
time tar -jcf usr_gettext.tar.bz2 usr

base64 -w 0 usr_gettext.tar.bz2 > usr_gettext.tar.bz2.base64.txt

ls -lang

set +x
base64_text=$(cat /tmp/usr_gettext.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('usr_gettext.tar.bz2', '${base64_text}');
__HEREDOC__
set -x

echo ${start_date}
date
