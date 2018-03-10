#!/bin/bash

set -x

expect -c "
set timeout 5
spawn /app/heroku-cli/bin/heroku info ${APP_NAME}
expect \"Email:\"
send \"${PARAM1}\n\"
expect \"Password:\"
send \"${PARAM2}\n\"
exit 0
"
