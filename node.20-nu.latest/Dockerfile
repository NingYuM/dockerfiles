# syntax=docker/dockerfile:latest

# Nu: 0.98.0, Node: v20.17.0 LTS, npm: 10.8.2, pnpm: 9.9.0, Git: 2.39.2, fnm 1.37.1
# GNU bash: 5.2.15, Wget 1.21.3, aria2: 1.36.0, curl: 7.88.1, ripgrep 13.0.0, sd 1.0.0
# /etc/os-release: Debian GNU/Linux 12 (bookworm)
# Kernel: Linux bdbfa1bb3a92 6.4.16-linuxkit #1 SMP PREEMPT_DYNAMIC Thu Nov 16 10:55:59 UTC 2023 x86_64 GNU/Linux
# Build cmd: docker build . -t hustcer/debian-nu:0.98-node.20.17.lts --no-cache
# docker buildx build --platform linux/amd64,linux/arm64 . -t hustcer/debian-nu:0.98-node.20.17.lts --no-cache
# Other tags: terminus/debian-nu:0.98-n20.17,terminus/debian-nu:0.98
FROM node:20.17.0-bookworm-slim

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/amd64/x86_64}

LABEL maintainer=hustcer<hustcer@outlook.com>

# Use mirrors to speed up installation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install apt-transport-https ca-certificates locales -y --no-install-recommends --no-install-suggests \
    # Change locale & timezone
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib' > /etc/apt/sources.list \
    && echo 'deb https://mirrors.aliyun.com/debian-security/ bookworm-security main' >> /etc/apt/sources.list \
    && echo 'deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib' >> /etc/apt/sources.list \
    && echo 'deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib' >> /etc/apt/sources.list

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV NODEJS_ORG_MIRROR="https://npmmirror.com/dist"
ENV SASS_BINARY_SITE="https://npmmirror.com/mirrors/node-sass"

RUN npm config set @terminus:registry https://registry.npm.terminus.io/ \
    && npm config set registry https://registry.npmmirror.com/ \
    && npm i --location=global pnpm@9 \
    # Fix "Unable to find the global bin directory" error while running `pnpm i -g`
    && pnpm config set global-bin-dir '/usr/local/bin' \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests wget aria2 curl git unzip ripgrep \
    && cd /lib; curl -s https://api.github.com/repos/chmln/sd/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-unknown-linux-musl | aria2c -i - \
    && mkdir sd-latest && tar xvf sd-*.tar.gz --directory=sd-latest \
    && cp -aR sd-latest/**/sd /usr/local/bin/; rm -rf sd-* \
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
    # Just do: fnm install 16 && fnm use 16, will finish in 10 seconds.
    && curl -fsSL https://fnm.vercel.app/install | bash \
    # Fix: fnm can't infer your shell based on the process tree.
    && sed -i 's/fnm env/fnm env --shell=bash/' /root/.bashrc \
    && cd /lib; curl -s https://api.github.com/repos/nushell/nushell/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-unknown-linux-gnu | aria2c -i - \
    && mkdir nu-latest && tar xvf nu-*.tar.gz --directory=nu-latest \
    && cp -aR nu-latest/**/* /usr/local/bin/ \
    # Setup default config file for nushell
    && mkdir -p /root/.config/nushell && cd /root/.config/nushell \
    && touch env.nu config.nu \
    && nu -c 'config reset' \
    && echo '$env.PNPM_HOME = "/usr/local/bin"' >> /root/.config/nushell/env.nu \
    # Cleanup nu source and cargo caches, etc.
    && cd /lib; rm -rf nu-* \
    && rm -rf /var/lib/apt/lists/* && apt autoremove -y \
    # Add and erda user and create home dir
    && useradd -m -s /bin/bash erda

CMD [ "nu" ]
