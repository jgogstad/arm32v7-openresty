FROM arm32v7/debian:jessie

RUN apt-get update && apt-get install -y \
      curl \
      perl \
      make \
      dnsutils \
      build-essential \
      libreadline-dev \
      libncurses5-dev \
      libpcre3-dev \
      libssl-dev

ENV OPENRESTY_VERSION 1.13.6.2

RUN curl -sSLO https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
  curl -sSLO https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz.asc && \
  gpg --keyserver pgpkeys.mit.edu --recv-key A0E98066 && \
  gpg --verify openresty-${OPENRESTY_VERSION}.tar.gz.asc

RUN tar -zxvf openresty-${OPENRESTY_VERSION}.tar.gz && \
      cd openresty-* && \
      ./configure -j2 && \
      make && \
      make install

RUN apt-get purge -y \
      perl \
      make \
      build-essential \
      libreadline-dev \
      libncurses5-dev \
      libpcre3-dev && \
      apt-get autoremove -y && \
      apt-get clean

ENV PATH=/usr/local/openresty/bin:$PATH

ENTRYPOINT ["openresty", "-g", "daemon off;"]

