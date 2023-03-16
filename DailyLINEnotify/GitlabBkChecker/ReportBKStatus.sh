#!/bin/bash
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
today=$(date +"%Y-%m-%d")

sh /root/larry/GitlabBkChecker/GitlabBkChecker.sh

message=$(cat /root/larry/GitlabBkChecker/nowstatus.log)
notice="${message}"
#發送信息

#larry
#TOKEN="0S8gVoYlcOIOeWxxwkHyf1uBAxwVrdy5wumbxSCD4In"

#9splay
TOKEN="iFRBzxPvCzvgxx5w5flJESI9B6XA8d1QixSCYsBbS6J"
curl https://notify-api.line.me/api/notify -H "Authorization: Bearer ${TOKEN}" -d "message=${notice}"
