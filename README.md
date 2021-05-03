# GK-2A_Hirez_Docker
Docker for GK-2A decoding, from [**bclswl0827/GK2A-Docker**](https://github.com/bclswl0827/GK2A-Docker), 
modified by [**tcjj3**](https://github.com/tcjj3), using [**sam210723/xrit-rx**](https://github.com/sam210723/xrit-rx), [**sam210723/goestools**](https://github.com/sam210723/goestools) and [**nullpainter/sanchez**](https://github.com/nullpainter/sanchez).


# Quick Start

Install docker-ce, example given on Debian.

```
[tcjj3@debian]$ sudo apt install -y curl
[tcjj3@debian]$ curl -fsSL get.docker.com -o get-docker.sh
[tcjj3@debian]$ sudo sh get-docker.sh
[tcjj3@debian]$ sudo groupadd docker
[tcjj3@debian]$ sudo usermod -aG docker $USER
[tcjj3@debian]$ sudo systemctl enable docker && sudo systemctl start docker
```

Run GK-2A_Hirez_Docker.

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

**If you are using down-converter for GK-2A, just set the `FREQ` environment variables to the new frequency (default is `1692140000` Hz).**


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

2. Filebrowser:
```
http://[Your IP]:8888
```
