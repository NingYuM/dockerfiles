# syntax=docker/dockerfile:latest

# Git: git version 2.39.2, curl: 7.88.1, Wget: 1.21.3, Python 3.11.2
# Node: 20.17.0 LTS, npm: 10.8.2, pnpm: 9.9.0, fnm: 1.37.1, gcc: 12.2.0, bash: 5.2.15
# herd: 1.1.27, fd: 10.2.0, ripgrep 13.0.0, VIM - Vi IMproved 9.0
# /etc/os-release: Debian GNU/Linux 12 (bookworm)
# Linux cc755cd59f63 6.10.0-linuxkit #1 SMP Wed Jul 17 10:51:09 UTC 2024 aarch64 GNU/Linux
# Build cmd: docker build . -t hustcer/debian-node:20.17 --no-cache
# Other tags: hustcer/debian-node:20.17-lts,hustcer/debian-node:20.17
FROM node:20.17.0-bookworm-slim

LABEL maintainer=hustcer<hustcer@outlook.com>

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
ENV NODEJS_ORG_MIRROR="https://npmmirror.com/dist"
ENV SASS_BINARY_SITE="https://npmmirror.com/mirrors/node-sass"

RUN npm config set @terminus:registry https://registry.npm.terminus.io/ \
    && npm config set registry https://registry.npmmirror.com/ \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       # Network related utils
       wget curl telnet tcpdump net-tools dnsutils iputils-ping \
       # Dev related
       git gcc make g++ vim \
       # SEE: https://github.com/BurntSushi/ripgrep
       # SEE: https://github.com/sharkdp/fd#installation
       tree fd-find ripgrep htop bzip2 unzip lsof procps \
    # Make /bin/sh symlink to bash instead of dash:
    # REF: https://groups.google.com/g/linux.debian.user/c/2CyfM5UrSOI?pli=1
    && dpkg-divert --remove --no-rename /usr/share/man/man1/sh.1.gz \
    && dpkg-divert --remove --no-rename /bin/sh \
    && ln -sf bash.1.gz /usr/share/man/man1/sh.1.gz \
    && ln -sf bash /bin/sh \
    && dpkg-divert --add --local --no-rename /usr/share/man/man1/sh.1.gz \
    && dpkg-divert --add --local --no-rename /bin/sh \
    # fnm --- Reserved expansion point:
    # See: https://github.com/Schniz/fnm, Fast and simple Node version manager
    # Make it easier and faster to switch to other node versions in the future
    # Just do: fnm install 20 && fnm use 20, will finish in 10 seconds.
    && curl -fsSL https://fnm.vercel.app/install | bash \
    # Fix: fnm can't infer your shell based on the process tree.
    && sed -i 's/fnm env/fnm env --shell=bash/' /root/.bashrc \
    # Setup root alias
    && echo "# Setup user alias" >> /root/.bashrc \
    && echo "alias ..='cd ..'" >> /root/.bashrc \
    && echo "alias fd='fdfind'" >> /root/.bashrc \
    && echo "alias ls='ls --color'" >> /root/.bashrc \
    && echo "alias ll='ls -l --color'" >> /root/.bashrc \
    # Fix vim encoding for cjk characters
    && echo 'set enc=utf8' >> /etc/vim/vimrc \
    && echo 'set fencs=utf8,gbk,gb2312,gb18030' >> /etc/vim/vimrc \
    # Add --unsafe-perm to fix 'Error: EACCES: permission denied, mkdir...' issue while install node-sass
    && npm i -g --unsafe-perm @terminus/herd@1.1.27 \
    && npm i -g pnpm@latest \
    # Fix "Unable to find the global bin directory" error while running `pnpm i -g`
    && pnpm config set global-bin-dir '/usr/local/bin' \
    && rm -rf /var/lib/apt/lists/* && apt autoremove -y \
    # Add erda user and create home dir
    && useradd -m -s /bin/bash erda

CMD [ "herd" ]

