FROM debian:bullseye
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y -qq apt-utils 2>&1
RUN apt-get upgrade -y -qq
RUN apt-get install git wget curl unzip sudo jq vim file -y -qq
RUN apt-get install coreutils -y -qq
RUN apt-get install nmap masscan chromium -y -qq
RUN apt-get autoremove -y 

ENV PATH "$PATH:/root/osmedeus-base/binaries/"
WORKDIR /root/

RUN curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/main/install-macos.sh -o /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

EXPOSE 8000
CMD ["/usr/local/bin/osmedeus","server"]
ENTRYPOINT ["osmedeus"]
