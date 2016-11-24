#!/bin/sh
cat /supervisord.pid | xargs kill -SIGHUP

while [ true ];
do
    COUNT=`ps aux | grep unoconv | grep -v grep | wc | awk '{print $1}'`
    if [ $COUNT -eq "1" ]
    then
        break
    fi
    sleep 0.1
done