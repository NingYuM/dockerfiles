# version   : "2.1.0"
# title     : hustcer/xelatex
# author    : "Justin Ma" <hustcer@outlook.com>
# Build cmd : docker build . -t hustcer/xelatex
# Other tags: hustcer/xelatex:v2.1
FROM debian:bookworm-slim

LABEL version="2.1.0"
LABEL title="hustcer/xelatex"
LABEL authors="Justin Ma <hustcer@outlook.com>"

# Use mirrors to speed up installation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install apt-transport-https ca-certificates locales -y --no-install-recommends --no-install-suggests \
    && echo 'deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib' > /etc/apt/sources.list \
    && echo 'deb https://mirrors.aliyun.com/debian-security/ bookworm-security main' >> /etc/apt/sources.list \
    && echo 'deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    # Change locale & timezone
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    # Fix: copy and paste CJK characters in terminal.
    && echo 'set input-meta on' > /root/.inputrc \
    && echo 'set output-meta on' > /root/.inputrc \
    && echo 'set convert-meta off' > /root/.inputrc \
    && echo 'set enable-meta-key on' > /root/.inputrc \
    && echo "Asia/Shanghai" > /etc/timezone \
    && cp -a /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install all TeX and LaTeX dependences
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
      git \
      inotify-tools \
      lmodern \
      make \
      texlive-fonts-recommended \
      texlive-lang-english \
      texlive-lang-portuguese \
      texlive-plain-generic \
      texlive-xetex \
  && apt-get autoclean && apt-get --purge --yes autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Export the output data
WORKDIR /data
VOLUME ["/data"]
