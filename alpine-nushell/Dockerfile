# syntax=docker/dockerfile:latest

# Git: git version 2.30.2
# /etc/os-release: Alpine Linux v3.16
# Kernel: Linux ca3abedc4fb1 5.17.15-76051715-generic #202206141358~1655919116~22.04~1db9e34 SMP PREEMPT Wed Jun 22 19 x86_64 Linux
# Build cmd: docker build --no-cache . -t nushell-latest
# Other tags: hustcer/alpine-nu:latest, nushell
FROM alpine

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/amd64/x86_64}

LABEL maintainer=hustcer

RUN echo '/usr/bin/nu' >> /etc/shells \
    && adduser -D -s /usr/bin/nu nushell \
    && mkdir -p /home/nushell/.config/nushell/ \
    && cd /tmp \
    && curl -s https://api.github.com/repos/nushell/nushell/releases/latest \
        | grep browser_download_url \
        | cut -d '"' -f 4 \
        | grep ${ARCH}-unknown-linux-gnu \
        | aria2c -i - \
    && mkdir nu-latest && tar xvf nu-*.tar.gz --directory=nu-latest \
    && cp -aR nu-latest/**/* /usr/bin/ \
    # Setup default config file for nushell
    && mkdir -p /home/nushell/.config/nushell && cd /home/nushell/.config/nushell \
    && touch env.nu config.nu \
    && nu -c 'config reset' \
    && chmod +x /usr/bin/nu \
    && chown -R nushell:nushell /home/nushell/.config/nushell \
    && ls /usr/bin/nu_plugin* \
        | xargs -I{} su -c 'plugin add {}' nushell \
    && rm -rf /tmp/*

USER nushell

WORKDIR /home/nushell

ENTRYPOINT ["nu"]
