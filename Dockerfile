FROM ubuntu:20.04

RUN useradd -m shakugan && echo "shakugan:AliAly032230" | chpasswd && adduser shakugan sudo
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt update && apt-get upgrade -y
RUN apt-get install tzdata locales
RUN locale-gen en_US.UTF-8
RUN apt-get install -y wget sudo curl nano git xz-utils openssh-server build-essential net-tools dialog apt-utils libevent* libsecret* tasksel slim; \
    apt --fix-broken install && apt clean;

# sshd
RUN mkdir -p /var/run/sshd
RUN sed -i 's\#PermitRootLogin prohibit-password\PermitRootLogin yes\ ' /etc/ssh/sshd_config
RUN sed -i 's\#PubkeyAuthentication yes\PubkeyAuthentication yes\ ' /etc/ssh/sshd_config
RUN apt clean

# VSCODETOr
RUN wget https://github.com/coder/code-server/releases/download/v4.9.1/code-server_4.9.1_amd64.deb
RUN dpkg -i code-server_4.9.1_amd64.deb
RUN wget -O - https://deb.nodesource.com/setup_18.x | bash && apt-get -y install nodejs && npm i -g updates
RUN wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.12-1~focal+1_amd64.deb
RUN dpkg -i tor_0.4.7.12-1~focal+1_amd64.deb
RUN sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
RUN sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
RUN sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
RUN sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
RUN sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
RUN sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 12345 127.0.0.1:12345\ ' /etc/tor/torrc
RUN sed -i '73s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
RUN sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
RUN sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
RUN sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
RUN rm -rf code-server_4.9.1_amd64.deb tor_0.4.7.12-1~focal+1_amd64.deb
RUN apt clean

# CONFIG
RUN echo "code-server --bind-addr 127.0.0.1:12345 >> vscode.log &"  >>/VSCODETOr.sh
RUN echo "tor > tor.log &"  >>/VSCODETOr.sh
RUN echo 'echo "######### wait Tor #########"' >>/VSCODETOr.sh
RUN echo 'sleep 1m' >>/VSCODETOr.sh
RUN echo "cat /var/lib/tor/hidden_service/hostname" >>/VSCODETOr.sh
RUN echo "sed -n '3'p ~/.config/code-server/config.yaml" >>/VSCODETOr.sh
RUN echo 'echo "######### OK #########"' >>/VSCODETOr.sh
RUN echo 'sleep 90d' >>/VSCODETOr.sh

RUN chmod 755 /VSCODETOr.sh

EXPOSE 80

CMD  ./VSCODETOr.sh
