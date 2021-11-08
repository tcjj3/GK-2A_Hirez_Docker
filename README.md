# GK-2A_Hirez_Docker
Docker for GK-2A decoding, from [**bclswl0827/GK2A-Docker**](https://github.com/bclswl0827/GK2A-Docker), 
modified by [**tcjj3**](https://github.com/tcjj3), using [**sam210723/goestools**](https://github.com/sam210723/goestools), [**sam210723/xrit-rx**](https://github.com/sam210723/xrit-rx) and [**nullpainter/sanchez**](https://github.com/nullpainter/sanchez).


# Quick Start

1. Install docker-ce, example given on Debian:

```
[tcjj3@debian]$ sudo apt install -y curl
[tcjj3@debian]$ curl -fsSL get.docker.com -o get-docker.sh
[tcjj3@debian]$ sudo sh get-docker.sh
[tcjj3@debian]$ sudo groupadd docker
[tcjj3@debian]$ sudo usermod -aG docker $USER
[tcjj3@debian]$ sudo systemctl enable docker && sudo systemctl start docker
```

2. Run GK-2A_Hirez_Docker: <br>
   Note: The image has 3 architectures: `amd64`, `arm`, `arm64`. <br>
   Just change the tag "`latest`" to "`amd64`" for `amd64` architecture, "`arm`" for `arm` architecture, or "`arm64`" for `arm64` architecture. <br>
   Default tag "`latest`" is for `amd64` architecture.

```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**Replace the string `airspy` with `rtlsdr` in case of using RTL-SDR dongle instead of Airspy when deploying docker.**
<br>
**For RTL-SDR you can add a "`DEVICE_INDEX`" variable to define "`device_index`", for example "` -e DEVICE_INDEX=0 \`" defines "`device_index = 0`".**
<br>

**If you want to set `bias_tee` variable, just add a "`BIAS_TEE=true`" environment variable using "`-e`" argument. Like this:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you want to customize the `times` of generate animation pictures, just add a "`CONVERT_TIMES`" environment variable in it (default `CONVERT_TIMES` value is "`0000`"). The `times` are UTC times, included `hours` and `minutes`. Each `time` connnected with "`,`", like "`2200,0000`".**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e CONVERT_TIMES=2200,0000 \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you want to enable "`dashboard`" or "`filebrowser`" page proxy on `5005` port, just set `PROXY_DASHBOARD` or `PROXY_FILEBROWSER` environment variable to "`true`", and if you want to click a link to jump to the pages directly, just set `CREATE_DASHBOARD_LINK` or `CREATE_FILEBROWSER_LINK` environment variable to "`true`".**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e CONVERT_TIMES=2200,0000 \
 -e PROXY_DASHBOARD=true \
 -e CREATE_DASHBOARD_LINK=true \
 -e PROXY_FILEBROWSER=true \
 -e CREATE_FILEBROWSER_LINK=true \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you want to delay some script operations when receiving (for some slow CPUs, because the signal would unlock when other programs are heavy using the CPU), just set `DELAYWHENRECEIVING` environment variable to "`true`".**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e DELAYWHENRECEIVING=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e CONVERT_TIMES=2200,0000 \
 -e PROXY_DASHBOARD=true \
 -e CREATE_DASHBOARD_LINK=true \
 -e PROXY_FILEBROWSER=true \
 -e CREATE_FILEBROWSER_LINK=true \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you want to get the latest images (such as "`LatestFullDisk.jpg`", "`LatestFullDisk-fc.jpg`", "`LatestImage.jpg`" and "`LatestMerged.gif`") automatic, just set `SHOW_LATESTIMAGES` environment variable to "`true`", and if you want to click a link to jump to the images directly, just set `CREATE_LATESTIMAGES_LINKS` environment variable to "`true`".**
<br>
**The "`LATESTFULLDISK_CALLBACK`", "`LATESTFULLDISKFC_CALLBACK`", "`LATESTIMAGE_CALLBACK`" and "`LATESTMERGED_CALLBACK`" environment variables are set for the `Callback Function Names` to the "`LatestFullDisk.json`", "`LatestFullDisk-fc.json`", "`LatestImage.json`" and "`LatestMerged.json`". If these environment variables are `Empty Values` or `Not Setted`, then these files are just `JSON` but not `JSONP`.**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e DELAYWHENRECEIVING=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e CONVERT_TIMES=2200,0000 \
 -e PROXY_DASHBOARD=true \
 -e CREATE_DASHBOARD_LINK=true \
 -e PROXY_FILEBROWSER=true \
 -e CREATE_FILEBROWSER_LINK=true \
 -e SHOW_LATESTIMAGES=true \
 -e CREATE_LATESTIMAGES_LINKS=true \
 -e LATESTFULLDISK_CALLBACK="Callback_LatestFullDisk" \
 -e LATESTFULLDISKFC_CALLBACK="Callback_LatestFullDisk_fc" \
 -e LATESTMERGED_CALLBACK="Callback_LatestMerged" \
 -e LATESTIMAGE_CALLBACK="Callback_Latest_Image" \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you want to define the `samplerate` of your SDR, just set the `SAMPLE_RATE` environment variable to the `samplerate value`.**
<br>
**Here are some reference values of the `samplerate`: `2500000` for the `Airspy R2`, `3000000` for the `Airspy Mini`, and `1024000` for the `RTL-SDR`.**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e SAMPLE_RATE=2500000 \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e DELAYWHENRECEIVING=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e CONVERT_TIMES=2200,0000 \
 -e PROXY_DASHBOARD=true \
 -e CREATE_DASHBOARD_LINK=true \
 -e PROXY_FILEBROWSER=true \
 -e CREATE_FILEBROWSER_LINK=true \
 -e SHOW_LATESTIMAGES=true \
 -e CREATE_LATESTIMAGES_LINKS=true \
 -e LATESTFULLDISK_CALLBACK="Callback_LatestFullDisk" \
 -e LATESTFULLDISKFC_CALLBACK="Callback_LatestFullDisk_fc" \
 -e LATESTMERGED_CALLBACK="Callback_LatestMerged" \
 -e LATESTIMAGE_CALLBACK="Callback_Latest_Image" \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you don't want to `auto colour the LRIT pictures`, just set the `NOCOLOUR` environment variable to "`true`".**
<br>
**If you don't want to `auto convert the pictures to gif movie(s)`, just set the `NOCONVERT` environment variable to "`true`".**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e SAMPLE_RATE=2500000 \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -e BIAS_TEE=true \
 -e DELAYWHENRECEIVING=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e NOCOLOUR=true \
 -e NOCONVERT=true \
 -e CONVERT_TIMES=2200,0000 \
 -e PROXY_DASHBOARD=true \
 -e CREATE_DASHBOARD_LINK=true \
 -e PROXY_FILEBROWSER=true \
 -e CREATE_FILEBROWSER_LINK=true \
 -e SHOW_LATESTIMAGES=true \
 -e CREATE_LATESTIMAGES_LINKS=true \
 -e LATESTFULLDISK_CALLBACK="Callback_LatestFullDisk" \
 -e LATESTFULLDISKFC_CALLBACK="Callback_LatestFullDisk_fc" \
 -e LATESTMERGED_CALLBACK="Callback_LatestMerged" \
 -e LATESTIMAGE_CALLBACK="Callback_Latest_Image" \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you just want to `use it to convert the pictures from other server(s)`, set the `NORECEIVE` environment variable to "`true`", it will not try to receive anything and just start for convert pictures.**
<br>
**In the above example, if you want to `forward the Dashboard on 5005 port by this server`, just set the `DASHBOARDSERVER` environment variable to your `Dashboard Server IP Address And Port`, such as "`192.168.1.2:1692`".**
<br>
**For example:**
```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DELAYWHENRECEIVING=true \
 -e HIREZ=underlay_hirez \
 -e PM=pristinemask \
 -e NORECEIVE=true \
 -e CONVERT_TIMES=2200,0000 \
 -e DASHBOARDSERVER="192.168.1.2:1692" \
 -e PROXY_DASHBOARD=true \
 -e CREATE_DASHBOARD_LINK=true \
 -e PROXY_FILEBROWSER=true \
 -e CREATE_FILEBROWSER_LINK=true \
 -e SHOW_LATESTIMAGES=true \
 -e CREATE_LATESTIMAGES_LINKS=true \
 -e LATESTFULLDISK_CALLBACK="Callback_LatestFullDisk" \
 -e LATESTFULLDISKFC_CALLBACK="Callback_LatestFullDisk_fc" \
 -e LATESTMERGED_CALLBACK="Callback_LatestMerged" \
 -e LATESTIMAGE_CALLBACK="Callback_Latest_Image" \
 -p 5005:5005 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```


**If you don't want to use `Underlay-Hirez.jpg` or `PristineMask.jpg` for `Underlay` or `Mask`, just remove the `HIREZ` or the `PM` environment variables, like this:**

```
[tcjj3@debian]$ sudo docker volume create xrit-rx
[tcjj3@debian]$ sudo docker volume create xrit-rx_config
[tcjj3@debian]$ sudo docker run -d -i -t \
 --restart always \
 --name=goesrecv \
 --device /dev/bus/usb \
 -e DEVICE=airspy \
 -e GAIN=50 \
 -e FREQ=1692140000 \
 -p 1692:1692 \
 -p 5001:5001 \
 -p 5002:5002 \
 -p 5004:5004 \
 -p 5005:5005 \
 -p 6001:6001 \
 -p 6002:6002 \
 -p 8888:8888 \
 -v xrit-rx_config:/opt/xrit-rx_config \
 -v xrit-rx:/usr/local/bin/xrit-rx/src/received/LRIT \
 tcjj3/gk-2a_hirez_docker:latest
```

**If you are using down-converter for GK-2A, just set the `FREQ` environment variable to the new frequency (default is `1692140000` Hz).**
<br>


## Get Pictures

### Local Disk

```
[tcjj3@debian]$ cd /var/lib/docker/volumes/xrit-rx/_data
```



### Via HTTP


1. Website:
```
http://[Your IP]:5005
```
(1) If you set `PROXY_DASHBOARD` environment variable to "`true`", you can visit `Dashboard` at here:
```
http://[Your IP]:5005/dashboard
```
(2) If you set `PROXY_FILEBROWSER` environment variable to "`true`", you can visit `Filebrowser` at here:
```
http://[Your IP]:5005/files
```
<br>


2. Filebrowser:
```
http://[Your IP]:8888
```
<br>


3. Dashboard:
```
http://[Your IP]:1692
```


