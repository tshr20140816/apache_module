#!/bin/bash

set -x

date
start_date=$(date)

chmod 755 start_web.sh

export HOME2=${PWD}
export PATH="/tmp/usr/bin:${PATH}"

export CFLAGS="-march=native -O2"
export CXXFLAGS="$CFLAGS"

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

cd /tmp

mkdir -m 777 usr

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
SELECT file_base64_text
  FROM t_files
 WHERE file_name = 'usr_expect.tar.bz2'
__HEREDOC__

if [ $(cat /tmp/sql_result.txt | grep -c '(1 row)') -eq 1 ]; then
  set +x
  echo $(cat /tmp/sql_result.txt | head -n 3 | tail -n 1) > /tmp/usr.tar.bz2.base64.txt
  set -x
  base64 -d /tmp/usr.tar.bz2.base64.txt > /tmp/usr.tar.bz2
  tar xf /tmp/usr.tar.bz2 -C /tmp/usr --strip=1
  
  /tmp/usr/bin/expect -c "
set timeout 5
exp_internal 1
spawn /tmp/heroku-cli/bin/heroku info ${APP_NAME}
expect \"Email:\"
send \"${PARAM1}\n\"
expect \"Password:\"
send \"${PARAM2}\n\"
expect \"$\"
"
  exit
fi

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
mkdir -m 777 /tmp/heroku-cli

# tar xf heroku.tar.gz -C ${HOME2}/heroku-cli --strip=1
tar xf heroku.tar.gz -C /tmp/heroku-cli --strip=1


# *****

cd /tmp/usr

ls -Rlang

ldd ./bin/expect

cd /tmp

time tar -jcf usr.tar.bz2 usr
base64 -w 0 usr.tar.bz2 > usr.tar.bz2.base64.txt

set +x
base64_text=$(cat /tmp/usr.tar.bz2.base64.txt)

psql -U ${postgres_user} -d ${postgres_dbname} -h ${postgres_server} > /tmp/sql_result.txt << __HEREDOC__
INSERT INTO t_files (file_name, file_base64_text) VALUES ('usr_expect.tar.bz2', '${base64_text}');
__HEREDOC__
set -x

/tmp/usr/bin/expect -c "
set timeout 5
exp_internal 1
spawn /tmp/heroku-cli/bin/heroku info ${APP_NAME}
expect \"Email:\"
send \"${PARAM1}\n\"
expect \"Password:\"
send \"${PARAM2}\n\"
expect \"$\"
"

echo ${start_date}
date
