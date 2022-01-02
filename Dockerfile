FROM j3ssie/essential-build:latest
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
ENV PATH "$PATH:/root/osmedeus-base/binaries/"
WORKDIR /root/

RUN curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install.sh -o /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

EXPOSE 8000
CMD ["/usr/local/bin/osmedeus","server"]
ENTRYPOINT ["osmedeus"]
