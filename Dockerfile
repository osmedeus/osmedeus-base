FROM debian:bullseye
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update -qq && apt-get install -y locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
RUN apt-get install -y -qq apt-utils
RUN apt-get upgrade -y -qq
RUN apt-get install git wget curl unzip sudo jq vim file -y -qq
RUN apt-get install coreutils libpcap-dev -y -qq
RUN apt-get install nmap masscan chromium -y -qq
RUN apt-get autoremove -y 

WORKDIR /root/

# RUN curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/main/install-arm.sh -o /tmp/install.sh
COPY install-arm.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

ENV PATH="/root/osmedeus-base/binaries:${PATH}"
RUN osmedeus config set --threads-hold=10
RUN osmedeus health

EXPOSE 8000
CMD ["osmedeus"]