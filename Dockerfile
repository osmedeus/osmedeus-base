FROM debian:bullseye
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y -qq apt-utils 2>&1
RUN apt upgrade -y -qq
RUN apt install git wget curl unzip sudo jq vim file -y -qq
RUN apt install coreutils -y -qq
RUN apt install nmap masscan chromium -y -qq
RUN apt autoremove -y 

ENV PATH "$PATH:/root/osmedeus-base/binaries/"
WORKDIR /root/

RUN curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install-macos.sh -o /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

EXPOSE 8000
CMD ["/usr/local/bin/osmedeus","server"]
ENTRYPOINT ["osmedeus"]
