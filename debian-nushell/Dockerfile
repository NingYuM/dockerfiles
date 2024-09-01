# syntax=docker/dockerfile:latest

# Git: git version 2.30.2
# /etc/os-release: Debian Linux v12.6
# Kernel: Linux ca3abedc4fb1 5.17.15-76051715-generic #202206141358~1655919116~22.04~1db9e34 SMP PREEMPT Wed Jun 22 19 x86_64 Linux
# Build cmd: docker build --no-cache . -t hustcer/nushell:latest
# Other tags: hustcer/debian-nu:latest, nushell
FROM debian

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/amd64/x86_64}
ARG ARCH=${ARCH/riscv64/riscv64gc}

LABEL maintainer=hustcer

RUN echo '/usr/bin/nu' >> /etc/shells \
    && adduser --disabled-password --shell /usr/bin/nu --gecos "" nushell \
    && cd /tmp \
    && apt-get update && apt-get upgrade -y \
    && apt-get install apt-transport-https ca-certificates curl aria2 -y --no-install-recommends --no-install-suggests \
    && curl -s https://api.github.com/repos/nushell/nushell/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-unknown-linux-gnu | aria2c -i - \
    && mkdir nu-latest && tar xvf nu-*.tar.gz --directory=nu-latest \
    && cp -aR nu-latest/**/* /usr/bin/ \
    # Setup default config file for nushell
    && mkdir -p /root/.config/nushell && cd /root/.config/nushell \
    && touch env.nu config.nu \
    && chmod +x /usr/bin/nu \
    && chown -R nushell:nushell /root/.config/nushell \
    && nu -c 'config reset -w' \
    && ls /usr/bin/nu_plugin* | xargs -I{} nu -c 'plugin add {}' nushell \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/* && apt autoremove -y

ENTRYPOINT ["nu"]
