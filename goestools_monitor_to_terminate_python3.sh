#!/bin/sh









[ -f /tmp/noreceive ] && exit 0







while true; do


goesrecv_ps="$(ps -Af | grep goesrecv | grep -v grep)"

if [ -z "$goesrecv_ps" ]; then
killall python3 > /dev/null 2>&1
killall -9 python3 > /dev/null 2>&1
fi


sleep 1

done









