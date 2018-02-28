#!/bin/bash

export TZ=JST-9

url="https://logs-01.loggly.com/inputs/${LOGGLY_TOKEN}/tag/BUILD/"

curl -H 'content-type:text/plain' -d "$(cat -)" ${url}
