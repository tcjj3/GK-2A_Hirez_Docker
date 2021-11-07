FROM debian:buster-slim

LABEL maintainer "Original: Yuki Kikuchi <bclswl0827@yahoo.co.jp>, Modified: Chaojun Tan <https://github.com/tcjj3>"

ENV DOTNET_ROOT=/usr/local/bin/dotnet \
    PATH=$PATH:/usr/local/bin/dotnet

ADD gif.py /opt/gif.py
ADD colour.sh /opt/colour.sh
ADD convert.sh /opt/convert.sh
ADD goestools_monitor_to_terminate_python3.sh /opt/goestools_monitor_to_terminate_python3.sh
ADD set_convert_times.sh /opt/set_convert_times.sh
ADD LatestImage.htm /opt/LatestImage.htm
ADD latest_image_links.sh /opt/latest_image_links.sh
ADD entrypoint.sh /opt/entrypoint.sh

RUN export DIR_TMP="$(mktemp -d)" \
  && sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  && apt-get update \
  || echo "continue..." \
  && apt-get install --no-install-recommends -y cron \
                                                build-essential \
                                                ca-certificates \
                                                curl \
                                                wget \
                                                unzip \
                                                cmake \
                                                zlib1g-dev \
                                                make \
                                                libopencv-dev \
                                                git \
                                                python3-dev \
                                                python3-pip \
                                                libairspy-dev \
                                                librtlsdr-dev \
                                                graphicsmagick-imagemagick-compat \
                                                nginx \
                                                vim \
                                                psmisc \
                                                procps \
  && mkdir -p /etc/curlssl \
  && curl -kL http://curl.haxx.se/ca/cacert.pem -o /etc/curlssl/cacert.pem \
  && export CURL_CA_BUNDLE=/etc/curlssl/cacert.pem || echo "continue..." \
  && pip3 install setuptools || echo "continue..." \
  && chmod +x /opt/*.py \
  && chmod +x /opt/*.sh \
  && mkdir -p /etc/goestools /etc/caddy \
  && mkdir -p /opt/xrit-rx_config \
  && git clone --recursive https://github.com/sam210723/goestools ${DIR_TMP}/goestools \
  && cd ${DIR_TMP}/goestools \
  && sed -Ei "s#std::swap\(tmp, stats_\);#std::swap(tmp, stats_);\n      if (avg(tmp.gain) == 0 \&\& avg(tmp.frequency) == 0 \&\& avg(tmp.omega) == 0 \&\& avg(tmp.viterbiErrors) == 0 \&\& sum(tmp.reedSolomonErrors) == 0 \&\& tmp.totalOK == 0 \&\& tmp.totalDropped == 0) {\n        std::cout << \"Receive hardware error, exiting\!\\\\n\" << std::endl;\n        exit(1);\n      }#gi" src/goesrecv/monitor.cc || echo "continue..." \
  && mkdir -p ${DIR_TMP}/goestools/build \
  && cd ${DIR_TMP}/goestools/build \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local \
  && make -j${nproc} \
  && make install \
  && git clone https://github.com/sam210723/xrit-rx /usr/local/bin/xrit-rx \
  && mkdir -p /usr/local/bin/xrit-rx/src/received \
  && mkdir -p /usr/local/bin/xrit-rx/src/received/LRIT \
  && mkdir -p /usr/local/bin/xrit-rx/src/LatestImages \
  && cp -r /usr/local/bin/xrit-rx/src/html /usr/local/bin/xrit-rx/src/html_coloured \
  && cp /usr/local/bin/xrit-rx/src/html_coloured/js/dash.js /usr/local/bin/xrit-rx/src/html_coloured/js/dash.bak.js \
  && sed -i "s#if (ext != \"txt\") {#if (ext != \"txt\") {\n            if (url.indexOf(\"/FD/\") > -1) {\n                var fname_new = fname + \"-fc\";\n                \n                var url_old = url;\n                var Regex_FullDisk = /received\\\/LRIT\\\//i;\n                url = url.replace(Regex_FullDisk, \"received/LRIT/COLOURED/\");\n                Regex_FullDisk = /.jpg/i;\n                url = url.replace(Regex_FullDisk, \"-fc.jpg\");\n                Regex_FullDisk = /\\\/FD\\\//i;\n                url = url.replace(Regex_FullDisk, \"/\");\n            }\n#gi" /usr/local/bin/xrit-rx/src/html_coloured/js/dash.js \
  && sed -i "s#if (img.getAttribute(\"src\") != url) {#if (img.getAttribute(\"src\") != url) {\n                if (url_old != null \&\& url_old != \"\" \&\& url_old != url) {\n                    img.onerror = function() {img.setAttribute(\"src\", url_old); link.setAttribute(\"href\", url_old);};\n                    img.onload = function() {if (img.getAttribute(\"src\").indexOf(\"-fc\") > -1) cap.innerText = fname_new;};\n                } else {\n                    img.onerror = function() {};\n                    img.onload = function() {};\n                }\n#gi" /usr/local/bin/xrit-rx/src/html_coloured/js/dash.js \
  && cp /usr/local/bin/xrit-rx/src/html_coloured/js/dash.js /usr/local/bin/xrit-rx/src/html_coloured/js/dash_coloured.js \
  && cp /usr/local/bin/xrit-rx/src/html_coloured/index.html /usr/local/bin/xrit-rx/src/html_coloured/index.bak.html \
  && sed -i "s#\"js/dash.js\"#\"js/dash_coloured.js\"#gi" /usr/local/bin/xrit-rx/src/html_coloured/index.html \
  && pip3 install --no-cache-dir -r /usr/local/bin/xrit-rx/requirements.txt \
  && curl -L http://nmsc.kma.go.kr/resources/enhome/resources/satellites/coms/COMS_Decryption_Sample_Cpp.zip -o ${DIR_TMP}/COMS_Decryption_Sample_Cpp.zip \
  && unzip -j ${DIR_TMP}/COMS_Decryption_Sample_Cpp.zip EncryptionKeyMessage_001F2904C905.bin -d ${DIR_TMP} \
  && mv ${DIR_TMP}/EncryptionKeyMessage_001F2904C905.bin /usr/local/bin/xrit-rx/src/EncryptionKeyMessage_001F2904C905.bin \
  && python3 /usr/local/bin/xrit-rx/src/tools/keymsg-decrypt.py /usr/local/bin/xrit-rx/src/EncryptionKeyMessage_001F2904C905.bin 001F2904C905 \
  && cp /usr/local/bin/xrit-rx/src/xrit-rx.py /usr/local/bin/xrit-rx/src/xrit-rx.bak.py \
  && cp /usr/local/bin/xrit-rx/src/demuxer.py /usr/local/bin/xrit-rx/src/demuxer.bak.py \
  && cp /usr/local/bin/xrit-rx/src/ccsds.py /usr/local/bin/xrit-rx/src/ccsds.bak.py \
  && tmp=`grep "except OSError:" /usr/local/bin/xrit-rx/src/xrit-rx.py` || echo "continue..." \
  && [ -z "$tmp" ] && sed -Ei "s#except ConnectionResetError:#except OSError:\n                print(Fore.WHITE + Back.RED + Style.BRIGHT + \"CONNECTION DOES NOT EXIST\")\n                safe_stop()\n            except ConnectionResetError:#gi" /usr/local/bin/xrit-rx/src/xrit-rx.py || echo "continue..." \
  && tmp=`grep "except Exception as e:" /usr/local/bin/xrit-rx/src/xrit-rx.py | awk 'END{print NR}'` || echo "continue..." \
  && [ $((tmp)) -lt 2 ] && sed -i ':a;N;$!ba; s#\(.*\)safe_stop()\(.*\)#\1safe_stop()\nexcept Exception as e:\n    print(e)\n    safe_stop()\2#gi' /usr/local/bin/xrit-rx/src/xrit-rx.py || echo "continue..." \
  && tmp=`grep "self.demuxer.lastImage = self.cProduct.last" /usr/local/bin/xrit-rx/src/demuxer.py | awk 'END{print NR}'` || echo "continue..." \
  && [ $((tmp)) -lt 2 ] && sed -i ':a;N;$!ba; s#\(.*\)self.cProduct = None\(.*\)#\1self.demuxer.lastImage = self.cProduct.last\n                self.cProduct = None\2#gi' /usr/local/bin/xrit-rx/src/demuxer.py || echo "continue..." \
  && tmp=`grep "except ValueError:" /usr/local/bin/xrit-rx/src/ccsds.py` || echo "continue..." \
  && [ -z "$tmp" ] && (sed -Ei "s/self.PLAINTEXT = self.headerField \+ decData/#self.PLAINTEXT = self.headerField + decData/gi" /usr/local/bin/xrit-rx/src/ccsds.py && tmp=`grep "import colorama" /usr/local/bin/xrit-rx/src/ccsds.py` || echo "continue..." && ([ -z "$tmp" ] && sed -Ei "s#import os#import os\n\nimport colorama\nfrom colorama import Fore, Back, Style#gi" /usr/local/bin/xrit-rx/src/ccsds.py && sed -Ei "s#decData = decoder.decrypt\(self.dataField\)#try:\n            decData = decoder.decrypt(self.dataField)\n            self.PLAINTEXT = self.headerField + decData\n        except ValueError:\n            print(\"    \" + Fore.WHITE + Back.RED + Style.BRIGHT + \"DES ECB DECRYPT ERROR:   ValueError\")\n        else:\n            decData = None#gi" /usr/local/bin/xrit-rx/src/ccsds.py) || sed -Ei "s#decData = decoder.decrypt\(self.dataField\)#try:\n            decData = decoder.decrypt(self.dataField)\n            self.PLAINTEXT = self.headerField + decData\n        except ValueError:\n            print(\"    \" + \"DES ECB DECRYPT ERROR:   ValueError\")\n        else:\n            decData = None#gi" /usr/local/bin/xrit-rx/src/ccsds.py) || echo "continue..." \
  && pip3 install --no-cache-dir imageio \
  && mkdir -p /etc/nginx || echo "continue..." \
  && mkdir -p /etc/nginx/sites-available || echo "continue..." \
  && mkdir -p /etc/nginx/sites-enabled || echo "continue..." \
  && touch /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "server {" > /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	listen 4041 default_server;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	listen [::]:4041 default_server;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	root /usr/local/bin/xrit-rx/src/html;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	index index.html index.htm;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	server_name _;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	location / {" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "		try_files \$uri \$uri/ =404;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	}" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "}" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "server {" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	listen 4042 default_server;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	listen [::]:4042 default_server;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	root /usr/local/bin/xrit-rx/src/html_coloured;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	index index.html index.htm;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	server_name _;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	location / {" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "		try_files \$uri \$uri/ =404;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	}" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "}" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "server {" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	listen 4043 default_server;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	listen [::]:4043 default_server;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	root /usr/local/bin/xrit-rx/src/LatestImages;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	index index.html index.htm LatestFullDisk-fc.htm LatestFullDisk.htm LatestImage.htm LatestMerged.htm LatestFullDisk-fc.jpg LatestFullDisk.jpg LatestImage.jpg LatestMerged.gif;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	server_name _;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	location / {" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "		try_files \$uri \$uri/ =404;" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	}" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "	" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && echo "}" >> /etc/nginx/sites-available/dashboard_staticfiles || echo "continue..." \
  && ln -s /etc/nginx/sites-available/dashboard_staticfiles /etc/nginx/sites-enabled/dashboard_staticfiles || echo "continue..." \
  && if [ "$(dpkg --print-architecture)" = "armhf" ]; then \
        ARCH="arm7"; \
     else \
        ARCH=$(dpkg --print-architecture); \
     fi \
  && mkdir -p ${DIR_TMP}/caddy \
  && curl -L -o ${DIR_TMP}/caddy/caddy.tar.gz https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_${ARCH}.tar.gz \
  && tar -zxf ${DIR_TMP}/caddy/caddy.tar.gz -C ${DIR_TMP}/caddy \
  && mv ${DIR_TMP}/caddy/caddy /usr/local/bin/caddy \
  && curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash \
  && if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        ARCH="x64"; \
     elif [ "$(dpkg --print-architecture)" = "armhf" ]; then \
        ARCH="arm"; \
     else \
        ARCH=$(dpkg --print-architecture); \
     fi \
  && [ "$ARCH" = "arm" ] \
  && (curl -L -o ${DIR_TMP}/sanchez-v0.2.3-linux-arm.tar.gz https://github.com/nullpainter/sanchez/releases/download/v0.2.3/sanchez-v0.2.3-linux-arm.tar.gz \
  && tar zxf ${DIR_TMP}/sanchez-v0.2.3-linux-arm.tar.gz \
  && mv ${DIR_TMP}/sanchez-v0.2.3-linux-arm /usr/local/bin/sanchez \
  && curl -L https://github.com/nullpainter/sanchez/raw/41046435a10fa3e6ce7d440fd8bfe74e0d272b7e/Sanchez/Resources/GK-2A/PristineMask.jpg -o /usr/local/bin/sanchez/Resources/GK-2A/PristineMask.jpg \
  && curl -L https://github.com/nullpainter/sanchez/raw/41046435a10fa3e6ce7d440fd8bfe74e0d272b7e/Sanchez/Resources/GK-2A/Underlay-Hirez.jpg -o /usr/local/bin/sanchez/Resources/GK-2A/Underlay-Hirez.jpg \
  && rm -f ${DIR_TMP}/sanchez-v0.2.3-linux-arm.tar.gz) \
  || (mkdir -p ${DIR_TMP}/dotnet-sdk \
  && curl -L -o ${DIR_TMP}/dotnet-sdk.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/3.1.302/dotnet-sdk-3.1.302-linux-${ARCH}.tar.gz \
  && tar -zxf ${DIR_TMP}/dotnet-sdk.tar.gz -C ${DIR_TMP}/dotnet-sdk \
  && rm -rf ${DIR_TMP}/dotnet-sdk.tar.gz \
  && curl -L https://github.com/nullpainter/sanchez/archive/v0.2.3.tar.gz -o ${DIR_TMP}/sanchez-0.2.3.tar.gz \
  && tar zxf ${DIR_TMP}/sanchez-0.2.3.tar.gz -C ${DIR_TMP} \
  && cd ${DIR_TMP}/sanchez-0.2.3/Sanchez \
  && cp Sanchez.csproj Sanchez.csproj.bak \
  && sed -Ei "s#<None Update=\"Resources\\\\GK-2A\\\\Underlay.jpg\">#<None Update=\"Resources\\\\GK-2A\\\\PristineMask.jpg\"><CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory><ExcludeFromSingleFile>true</ExcludeFromSingleFile></None> <None Update=\"Resources\\\\GK-2A\\\\Underlay-Hirez.jpg\"><CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory><ExcludeFromSingleFile>true</ExcludeFromSingleFile></None> <None Update=\"Resources\\\\GK-2A\\\\Underlay.jpg\">#g" Sanchez.csproj \
  && export DOTNET_ROOT=${DIR_TMP}/dotnet-sdk \
            PATH=$PATH:${DIR_TMP}/dotnet-sdk \
  && dotnet restore --disable-parallel \
  && dotnet build --configuration Release --no-restore \
  && dotnet test --no-restore --verbosity normal \
  && mv bin/Release/netcoreapp3.1 /usr/local/bin/sanchez \
  && mkdir -p /tmp/sanchez_logs \
  && ln -s /tmp/sanchez_logs /usr/local/bin/sanchez/logs \
  && if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        ARCH="x64"; \
     elif [ "$(dpkg --print-architecture)" = "armhf" ]; then \
        ARCH="arm"; \
     else \
        ARCH=$(dpkg --print-architecture); \
     fi \
  && mkdir /usr/local/bin/dotnet \
  && curl -o ${DIR_TMP}/dotnet-runtime.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/3.1.6/dotnet-runtime-3.1.6-linux-${ARCH}.tar.gz \
  && tar -zxf ${DIR_TMP}/dotnet-runtime.tar.gz -C /usr/local/bin/dotnet) \
  && chmod +x /opt/* /usr/local/bin/xrit-rx/src/xrit-rx.py \
  && echo "4,14,24,34,44,54 * * * * /opt/colour.sh &" > ${DIR_TMP}/crontab \
  && echo "57 23 * * * /opt/convert.sh &" >> ${DIR_TMP}/crontab \
  && echo "* * * * * /opt/latest_image_links.sh &" >> ${DIR_TMP}/crontab \
  && crontab ${DIR_TMP}/crontab \
  && rm -rf ${DIR_TMP} \
  && apt-get autoremove --purge unzip make build-essential cmake git -y





ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]






