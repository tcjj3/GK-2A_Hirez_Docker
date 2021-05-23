#!/bin/sh






stringLength() {
len=`echo "$1" | awk '{printf("%d", length($0))}'`
echo "$len"
}








if [ -z "$DEVICE" ]; then
	echo >&2 'error: missing required DEVICE environment variable'
	echo >&2 '  Did you forget to -e DEVICE=... ?'
	exit 1
fi


if [ -z "$GAIN" ]; then
#	echo >&2 'error: missing required GAIN environment variable'
#	echo >&2 '  Did you forget to -e GAIN=... ?'
#	exit 1
	
	GAIN="50"
fi




if [ -z "$FREQ" ]; then
	FREQ="1692140000"
fi


if [ -z "$HIREZ" ]; then
	rm /tmp/underlay_hirez
else
	touch /tmp/underlay_hirez
fi


if [ -z "$PM" ]; then
	rm /tmp/pristinemask
else
	touch /tmp/pristinemask
fi




if [ $BIAS_TEE = "1" ]; then
	BIAS_TEE="true"
fi

if [ $BIAS_TEE = "0" ]; then
	BIAS_TEE="false"
fi

if [ $BIAS_TEE = "True" ]; then
	BIAS_TEE="true"
fi

if [ $BIAS_TEE = "False" ]; then
	BIAS_TEE="false"
fi

if [ $BIAS_TEE = "TRUE" ]; then
	BIAS_TEE="true"
fi

if [ $BIAS_TEE = "FALSE" ]; then
	BIAS_TEE="false"
fi

if [ ! -z "$BIAS_TEE" ]; then
	BIAS_TEE_STRING="bias_tee = $BIAS_TEE"
else
	BIAS_TEE_STRING=""
fi




if [ ! -z "$DEVICE_INDEX" ]; then
	DEVICE_INDEX_STRING="device_index = $DEVICE_INDEX"
else
	DEVICE_INDEX_STRING=""
fi






if [ $DEVICE = "airspy" ] ; then
cat << EOF > /etc/goestools/goesrecv.conf
[demodulator]
satellite = "GK-2A"
downlink = "lrit"
source = "airspy"
[airspy]
frequency = $FREQ
gain = $GAIN
$BIAS_TEE_STRING
[costas]
max_deviation = 200e3
[clock_recovery.sample_publisher]
bind = "tcp://0.0.0.0:5002"
send_buffer = 2097152
[quantization.soft_bit_publisher]
bind = "tcp://0.0.0.0:5001"
send_buffer = 1048576
[decoder.packet_publisher]
bind = "tcp://0.0.0.0:5004"
send_buffer = 1048576
[demodulator.stats_publisher]
bind = "tcp://0.0.0.0:6001"
[decoder.stats_publisher]
bind = "tcp://0.0.0.0:6002"
EOF
elif
	[ $DEVICE = "rtlsdr" ] ; then
cat << EOF > /etc/goestools/goesrecv.conf
[demodulator]
satellite = "GK-2A"
downlink = "lrit"
source = "rtlsdr"
[rtlsdr]
frequency = $FREQ
sample_rate = 1024000
gain = $GAIN
$BIAS_TEE_STRING
$DEVICE_INDEX_STRING
[costas]
max_deviation = 200e3
[clock_recovery.sample_publisher]
bind = "tcp://0.0.0.0:5002"
send_buffer = 2097152
[quantization.soft_bit_publisher]
bind = "tcp://0.0.0.0:5001"
send_buffer = 1048576
[decoder.packet_publisher]
bind = "tcp://0.0.0.0:5004"
send_buffer = 1048576
[demodulator.stats_publisher]
bind = "tcp://0.0.0.0:6001"
[decoder.stats_publisher]
bind = "tcp://0.0.0.0:6002"
EOF
else
	echo >&2 'error: incorrect DEVICE environment variable'
	echo >&2 '  Check your DEVICE string and deploy again?'
	exit 1
fi









if [ ! -z "$CONVERT_TIMES" ]; then
rm -rf /tmp/crontab
touch /tmp/crontab
echo "4,14,24,34,44,54 * * * * /opt/colour.sh &" > /tmp/crontab
rm -rf /tmp/crontab_
touch /tmp/crontab_
echo "$CONVERT_TIMES" | sed "s/,/\n/gi" | while read LINE; do
if [ ! -z "$LINE" ]; then
len=`stringLength "$LINE"`
index=`expr $len - 2`
Hours="${LINE:0:$index}"
Minutes="${LINE:$index:2}"

[ -z "$Hours" ] && Hours="23"
[ -z "$Minutes" ] && Minutes="57"

if [ "$Minutes" -gt "59" ]; then
Hours=`expr $Hours + 1`
Minutes="00"
fi
if [ "$Hours" -gt "23" ]; then
Hours="00"
Minutes="00"
fi

if [ "$Minutes" -eq "00" ] || [ "$Minutes" -eq "0" ]; then
if [ "$Hours" -gt "00" ] || [ "$Hours" -gt "0" ]; then
Hours=`expr $Hours - 1`
else
Hours="23"
fi
len_Hours=`stringLength "$Hours"`
[ "$len_Hours" -lt 2 ] && Hours="0$Hours"
Minutes="57"
else
Minutes_0=`expr ${Minutes:1:1}`
Minutes_1=`expr ${Minutes:0:1}`
if [ "$Minutes_0" -eq "0" ]; then
if [ "$Minutes_1" -gt "0" ]; then
Minutes_1=`expr ${Minutes_1} - 1`
else
if [ "$Hours" -gt "00" ] || [ "$Hours" -gt "0" ]; then
Hours=`expr $Hours - 1`
else
Hours="23"
fi
Minutes_1="5"
fi
fi
Minutes="${Minutes_1}7"
fi
len_Minutes=`stringLength "$Minutes"`
[ "$len_Minutes" -lt 2 ] && Minutes="0$Minutes"

echo "$Minutes $Hours * * * /opt/convert.sh &" >> /tmp/crontab_
fi
done
cat /tmp/crontab_ | sort -u >> /tmp/crontab
crontab /tmp/crontab
rm -rf /tmp/crontab
rm -rf /tmp/crontab_
fi


/etc/init.d/cron restart









cat << EOF > /etc/caddy/Caddyfile
0.0.0.0:5005 {
    root /usr/local/bin/xrit-rx/src/received/LRIT
    tls off
    gzip
    browse
}
EOF






rm -rf /tmp/resize_* > /dev/null 2>&1

#rm -rf /usr/local/bin/sanchez/logs > /dev/null 2>&1

rm -rf /tmp/sanchez_logs/* > /dev/null 2>&1
mkdir -p /tmp/sanchez_logs > /dev/null 2>&1






mkdir -p /usr/local/bin/xrit-rx/src/received/LRIT/COLOURED




# Path to save "filebrowser.db"
#cd /usr/local/bin/xrit-rx/src
cd /opt/xrit-rx_config




/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile &
/usr/local/bin/filebrowser -r /usr/local/bin/xrit-rx/src/received -p 8888 -a 0.0.0.0 &






/usr/local/bin/goesrecv -i 1 -c /etc/goestools/goesrecv.conf &

/opt/goestools_monitor_to_terminate_python3.sh &



cd /usr/local/bin/xrit-rx/src
/usr/bin/python3 xrit-rx.py






