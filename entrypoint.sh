#!/bin/sh






stringLength() {
len=`echo "$1" | awk '{printf("%d", length($0))}'`
echo "$len"
}







#Dashboard_StaticFiles_ServerPath="127.0.0.1:1692"
Dashboard_StaticFiles_ServerPath="127.0.0.1:4041"










if [ -z "$NORECEIVE" ]; then
if [ -z "$DEVICE" ]; then
	echo >&2 'error: missing required DEVICE environment variable'
	echo >&2 '  Did you forget to -e DEVICE=... ?'
	exit 1
fi
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


if [ -z "$NORECEIVE" ]; then
	rm /tmp/noreceive
else
	touch /tmp/noreceive
fi


if [ -z "$NOCOLOUR" ]; then
	rm /tmp/nocolour
else
	touch /tmp/nocolour
fi


if [ -z "$NOCONVERT" ]; then
	rm /tmp/noconvert
else
	touch /tmp/noconvert
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




if [ ! -z "$SAMPLE_RATE" ]; then
	SAMPLE_RATE_STRING="sample_rate = $SAMPLE_RATE"
else
	SAMPLE_RATE_STRING=""
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






if [ -z "$NORECEIVE" ]; then

if [ $DEVICE = "airspy" ] ; then
cat << EOF > /etc/goestools/goesrecv.conf
[demodulator]
satellite = "GK-2A"
downlink = "lrit"
source = "airspy"
[airspy]
frequency = $FREQ
$SAMPLE_RATE_STRING
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
$SAMPLE_RATE_STRING
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

fi









if [ ! -z "$CONVERT_TIMES" ]; then
/opt/set_convert_times.sh "$CONVERT_TIMES" > /dev/null 2>&1
fi


/etc/init.d/cron restart > /dev/null 2>&1












mkdir -p /usr/local/bin/xrit-rx/src/received/LRIT/COLOURED > /dev/null 2>&1






cat << EOF > /etc/caddy/Caddyfile
0.0.0.0:5005 {
    root /usr/local/bin/xrit-rx/src/received/LRIT
    tls off
    gzip
    browse
EOF






if [ $PROXY_DASHBOARD = "1" ]; then
	PROXY_DASHBOARD="true"
fi

if [ $PROXY_DASHBOARD = "0" ]; then
	PROXY_DASHBOARD="false"
fi

if [ $PROXY_DASHBOARD = "True" ]; then
	PROXY_DASHBOARD="true"
fi

if [ $PROXY_DASHBOARD = "False" ]; then
	PROXY_DASHBOARD="false"
fi

if [ $PROXY_DASHBOARD = "TRUE" ]; then
	PROXY_DASHBOARD="true"
fi

if [ $PROXY_DASHBOARD = "FALSE" ]; then
	PROXY_DASHBOARD="false"
fi

if [ $PROXY_DASHBOARD != "false" ] && [ ! -z "$PROXY_DASHBOARD" ]; then
cat << EOF >> /etc/caddy/Caddyfile
    
    
    proxy /dash ${Dashboard_StaticFiles_ServerPath} {
        without /dash
    }
    proxy /dashboard ${Dashboard_StaticFiles_ServerPath} {
        without /dashboard
    }
    proxy /db ${Dashboard_StaticFiles_ServerPath} {
        without /db
    }
    proxy /d ${Dashboard_StaticFiles_ServerPath} {
        without /d
    }
    proxy /xrit-rx ${Dashboard_StaticFiles_ServerPath} {
        without /xrit-rx
    }
    proxy /lrit-rx ${Dashboard_StaticFiles_ServerPath} {
        without /lrit-rx
    }
    proxy /hrit-rx ${Dashboard_StaticFiles_ServerPath} {
        without /hrit-rx
    }
    proxy /xritrx ${Dashboard_StaticFiles_ServerPath} {
        without /xritrx
    }
    proxy /lritrx ${Dashboard_StaticFiles_ServerPath} {
        without /lritrx
    }
    proxy /hritrx ${Dashboard_StaticFiles_ServerPath} {
        without /hritrx
    }
    proxy /xrit ${Dashboard_StaticFiles_ServerPath} {
        without /xrit
    }
    proxy /lrit ${Dashboard_StaticFiles_ServerPath} {
        without /lrit
    }
    proxy /hrit ${Dashboard_StaticFiles_ServerPath} {
        without /hrit
    }
    proxy /gk-2a ${Dashboard_StaticFiles_ServerPath} {
        without /gk-2a
    }
    proxy /gk2a ${Dashboard_StaticFiles_ServerPath} {
        without /gk2a
    }
    proxy /geo-kompsat-2a ${Dashboard_StaticFiles_ServerPath} {
        without /geo-kompsat-2a
    }
    proxy /geokompsat-2a ${Dashboard_StaticFiles_ServerPath} {
        without /geokompsat-2a
    }
    proxy /geo-kompsat2a ${Dashboard_StaticFiles_ServerPath} {
        without /geo-kompsat2a
    }
    proxy /geokompsat2a ${Dashboard_StaticFiles_ServerPath} {
        without /geokompsat2a
    }
    
    proxy /favicon.ico ${Dashboard_StaticFiles_ServerPath}
    proxy /css/dash.css ${Dashboard_StaticFiles_ServerPath}
    proxy /css/dash.css.map ${Dashboard_StaticFiles_ServerPath}
    proxy /css/dash.scss ${Dashboard_StaticFiles_ServerPath}
    proxy /js/dash.js ${Dashboard_StaticFiles_ServerPath}
    proxy /js/tools.js ${Dashboard_StaticFiles_ServerPath}
    
    proxy /api 127.0.0.1:1692
    proxy /api/current 127.0.0.1:1692
    proxy /api/latest 127.0.0.1:1692
    proxy /api/received 127.0.0.1:1692
EOF

/etc/init.d/nginx start > /dev/null 2>&1 &
fi


if [ $CREATE_DASHBOARD_LINK = "1" ]; then
	CREATE_DASHBOARD_LINK="true"
fi

if [ $CREATE_DASHBOARD_LINK = "0" ]; then
	CREATE_DASHBOARD_LINK="false"
fi

if [ $CREATE_DASHBOARD_LINK = "True" ]; then
	CREATE_DASHBOARD_LINK="true"
fi

if [ $CREATE_DASHBOARD_LINK = "False" ]; then
	CREATE_DASHBOARD_LINK="false"
fi

if [ $CREATE_DASHBOARD_LINK = "TRUE" ]; then
	CREATE_DASHBOARD_LINK="true"
fi

if [ $CREATE_DASHBOARD_LINK = "FALSE" ]; then
	CREATE_DASHBOARD_LINK="false"
fi

if [ $CREATE_DASHBOARD_LINK != "false" ] && [ ! -z "$CREATE_DASHBOARD_LINK" ]; then
#touch /usr/local/bin/xrit-rx/src/received/LRIT/dashboard > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > /usr/local/bin/xrit-rx/src/received/LRIT/dashboard
else
rm -rf /usr/local/bin/xrit-rx/src/received/LRIT/dashboard > /dev/null 2>&1
fi






if [ $PROXY_FILEBROWSER = "1" ]; then
	PROXY_FILEBROWSER="true"
fi

if [ $PROXY_FILEBROWSER = "0" ]; then
	PROXY_FILEBROWSER="false"
fi

if [ $PROXY_FILEBROWSER = "True" ]; then
	PROXY_FILEBROWSER="true"
fi

if [ $PROXY_FILEBROWSER = "False" ]; then
	PROXY_FILEBROWSER="false"
fi

if [ $PROXY_FILEBROWSER = "TRUE" ]; then
	PROXY_FILEBROWSER="true"
fi

if [ $PROXY_FILEBROWSER = "FALSE" ]; then
	PROXY_FILEBROWSER="false"
fi

if [ $PROXY_FILEBROWSER != "false" ] && [ ! -z "$PROXY_FILEBROWSER" ]; then
cat << EOF >> /etc/caddy/Caddyfile
    
    
    proxy /filebrowser 127.0.0.1:8888 {
        without /filebrowser
    }
    proxy /file 127.0.0.1:8888 {
        without /file
    }
    proxy /fb 127.0.0.1:8888 {
        without /fb
    }
    redir /files/filebrowser /files
    redir /api/resources/filebrowser /api/resources/
    redir /files/file /files
    redir /api/resources/file /api/resources/
    redir /files/fb /files
    redir /api/resources/fb /api/resources/
    proxy /files 127.0.0.1:8888
    proxy /login 127.0.0.1:8888
    proxy /api/login 127.0.0.1:8888
    proxy /api/signup 127.0.0.1:8888
    proxy /api/renew 127.0.0.1:8888
    proxy /static/js 127.0.0.1:8888
    proxy /static/img 127.0.0.1:8888
    proxy /static/css 127.0.0.1:8888
    proxy /static/fonts 127.0.0.1:8888
    proxy /static 127.0.0.1:8888
    proxy /api/resources 127.0.0.1:8888
    proxy /settings/profile 127.0.0.1:8888
    proxy /api/shares 127.0.0.1:8888
    proxy /settings/users 127.0.0.1:8888
    proxy /api/users 127.0.0.1:8888
    proxy /settings/shares 127.0.0.1:8888
    proxy /settings/global 127.0.0.1:8888
    proxy /api/settings 127.0.0.1:8888
    proxy /api/preview/thumb 127.0.0.1:8888
    proxy /api/preview/big 127.0.0.1:8888
    proxy /api/raw 127.0.0.1:8888
    proxy /api/command 127.0.0.1:8888 {
        websocket
        header_upstream -Origin
    }
    proxy /share 127.0.0.1:8888
    proxy /api/share 127.0.0.1:8888
    proxy /api/shares 127.0.0.1:8888
    proxy /api/public/share 127.0.0.1:8888
    proxy /api/public/dl 127.0.0.1:8888
    proxy /api/search 127.0.0.1:8888
EOF
fi


if [ $CREATE_FILEBROWSER_LINK = "1" ]; then
	CREATE_FILEBROWSER_LINK="true"
fi

if [ $CREATE_FILEBROWSER_LINK = "0" ]; then
	CREATE_FILEBROWSER_LINK="false"
fi

if [ $CREATE_FILEBROWSER_LINK = "True" ]; then
	CREATE_FILEBROWSER_LINK="true"
fi

if [ $CREATE_FILEBROWSER_LINK = "False" ]; then
	CREATE_FILEBROWSER_LINK="false"
fi

if [ $CREATE_FILEBROWSER_LINK = "TRUE" ]; then
	CREATE_FILEBROWSER_LINK="true"
fi

if [ $CREATE_FILEBROWSER_LINK = "FALSE" ]; then
	CREATE_FILEBROWSER_LINK="false"
fi

if [ $CREATE_FILEBROWSER_LINK != "false" ] && [ ! -z "$CREATE_FILEBROWSER_LINK" ]; then
#touch /usr/local/bin/xrit-rx/src/received/LRIT/files > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > /usr/local/bin/xrit-rx/src/received/LRIT/files
else
rm -rf /usr/local/bin/xrit-rx/src/received/LRIT/files > /dev/null 2>&1
fi




cat << EOF >> /etc/caddy/Caddyfile
    
    
    header / Access-Control-Allow-Origin *
}
EOF










rm -rf /tmp/resize_* > /dev/null 2>&1

#rm -rf /usr/local/bin/sanchez/logs > /dev/null 2>&1

rm -rf /tmp/sanchez_logs/* > /dev/null 2>&1
mkdir -p /tmp/sanchez_logs > /dev/null 2>&1






# Path to save "filebrowser.db"
#cd /usr/local/bin/xrit-rx/src > /dev/null 2>&1
cd /opt/xrit-rx_config > /dev/null 2>&1




/usr/local/bin/caddy --conf=/etc/caddy/Caddyfile > /dev/null 2>&1 &
/usr/local/bin/filebrowser -r /usr/local/bin/xrit-rx/src/received -p 8888 -a 0.0.0.0 > /dev/null 2>&1 &






if [ -z "$NORECEIVE" ]; then
/usr/local/bin/goesrecv -i 1 -c /etc/goestools/goesrecv.conf > /dev/null 2>&1 &

/opt/goestools_monitor_to_terminate_python3.sh > /dev/null 2>&1 &
fi




cd /usr/local/bin/xrit-rx/src > /dev/null 2>&1

if [ -z "$NORECEIVE" ]; then
/usr/bin/python3 xrit-rx.py > /dev/null 2>&1
else
/bin/bash > /dev/null 2>&1
fi






