FROM debian:buster-slim

LABEL maintainer "Original: Yuki Kikuchi <bclswl0827@yahoo.co.jp>, Modified: Chaojun Tan <https://github.com/tcjj3>"

ENV DOTNET_ROOT=/usr/local/bin/dotnet \
    PATH=$PATH:/usr/local/bin/dotnet

ADD gif.py /opt/gif.py
ADD colour.sh /opt/colour.sh
ADD convert.sh /opt/convert.sh
ADD goesrecv_monitor_to_terminate_python3.sh /opt/goesrecv_monitor_to_terminate_python3.sh
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
                                                unzip \
                                                cmake \
                                                zlib1g-dev \
                                                make \
                                                libopencv-dev \
                                                git \
                                                python3 \
                                                python3-pip \
                                                libairspy-dev \
                                                librtlsdr-dev \
                                                graphicsmagick-imagemagick-compat \
                                                psmisc \
                                                procps \
  && chmod +x /opt/*.py \
  && chmod +x /opt/*.sh \
  && mkdir -p /etc/goestools /etc/caddy \
  && mkdir -p /opt/xrit-rx_config \
  && git clone --recursive https://github.com/sam210723/goestools ${DIR_TMP}/goestools \
  && cd ${DIR_TMP}/goestools \
  && sed -Ei "s#std::swap\(tmp, stats_\);#std::swap(tmp, stats_);\n      if (avg(tmp.gain) == 0 \&\& avg(tmp.frequency) == 0 \&\& avg(tmp.omega) == 0 \&\& avg(tmp.viterbiErrors) == 0 \&\& sum(tmp.reedSolomonErrors) == 0 \&\& tmp.totalOK == 0 \&\& tmp.totalDropped == 0) {\n        std::cout << \"Receive hardware error, exiting\!\\\\n\" << std::endl;\n        exit(1);\n      }#gi" src/goesrecv/monitor.cc || echo "continue..." \
  && mkdir -p  ${DIR_TMP}/goestools/build \
  && cd ${DIR_TMP}/goestools/build \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local \
  && make -j${nproc} \
  && make install \
  && git clone https://github.com/sam210723/xrit-rx /usr/local/bin/xrit-rx \
  && mkdir -p /usr/local/bin/xrit-rx/src/received \
  && pip3 install --no-cache-dir -r /usr/local/bin/xrit-rx/requirements.txt \
  && curl -L http://nmsc.kma.go.kr/resources/enhome/resources/satellites/coms/COMS_Decryption_Sample_Cpp.zip -o ${DIR_TMP}/COMS_Decryption_Sample_Cpp.zip \
  && unzip -j ${DIR_TMP}/COMS_Decryption_Sample_Cpp.zip EncryptionKeyMessage_001F2904C905.bin -d ${DIR_TMP} \
  && mv ${DIR_TMP}/EncryptionKeyMessage_001F2904C905.bin /usr/local/bin/xrit-rx/src/EncryptionKeyMessage_001F2904C905.bin \
  && python3 /usr/local/bin/xrit-rx/src/tools/keymsg-decrypt.py /usr/local/bin/xrit-rx/src/EncryptionKeyMessage_001F2904C905.bin 001F2904C905 \
  && pip3 install --no-cache-dir imageio \
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
  && mkdir -p ${DIR_TMP}/dotnet-sdk \
  && curl -L -o ${DIR_TMP}/dotnet-sdk.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/3.1.302/dotnet-sdk-3.1.302-linux-${ARCH}.tar.gz \
  && tar -zxf ${DIR_TMP}/dotnet-sdk.tar.gz -C ${DIR_TMP}/dotnet-sdk \
  && rm -rf ${DIR_TMP}/dotnet-sdk.tar.gz \
  && curl -L https://github.com/nullpainter/sanchez/archive/v0.2.3.tar.gz -o ${DIR_TMP}/sanchez-0.2.3.tar.gz \
  && tar zxvf ${DIR_TMP}/sanchez-0.2.3.tar.gz -C ${DIR_TMP} \
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
  && tar -zxf ${DIR_TMP}/dotnet-runtime.tar.gz -C /usr/local/bin/dotnet \
  && chmod +x /opt/* /usr/local/bin/xrit-rx/src/xrit-rx.py \
  && echo "4,14,24,34,44,54 * * * * /opt/colour.sh &" > ${DIR_TMP}/crontab \
  && echo "57 23 * * * /opt/convert.sh &" >> ${DIR_TMP}/crontab \
  && crontab ${DIR_TMP}/crontab \
  && rm -rf ${DIR_TMP} \
  && apt-get autoremove --purge curl unzip ca-certificates make build-essential cmake git -y





ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]






