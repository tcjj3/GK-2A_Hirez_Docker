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
/opt/set_convert_times.sh "$CONVERT_TIMES" > /dev/null 2>&1
fi


/etc/init.d/cron restart > /dev/null 2>&1









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






mkdir -p /usr/local/bin/xrit-rx/src/received/LRIT/COLOURED > /dev/null 2>&1




# Path to save "filebrowser.db"
#cd /usr/local/bin/xrit-rx/src > /dev/null 2>&1
cd /opt/xrit-rx_config > /dev/null 2>&1




/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile > /dev/null 2>&1 &
/usr/local/bin/filebrowser -r /usr/local/bin/xrit-rx/src/received -p 8888 -a 0.0.0.0 > /dev/null 2>&1 &






/usr/local/bin/goesrecv -i 1 -c /etc/goestools/goesrecv.conf > /dev/null 2>&1 &

/opt/goestools_monitor_to_terminate_python3.sh > /dev/null 2>&1 &



cd /usr/local/bin/xrit-rx/src > /dev/null 2>&1
/usr/bin/python3 xrit-rx.py > /dev/null 2>&1






