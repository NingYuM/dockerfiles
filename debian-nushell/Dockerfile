# syntax=docker/dockerfile:latest

# REF:
#   - https://docker-practice.github.io/zh-cn/buildx/multi-arch-images.html

# /etc/os-release: Debian GNU/Linux 12 (bookworm)
# Kernel: Linux c02c605f827d 6.10.0-linuxkit #1 SMP Wed Jul 17 10:51:09 UTC 2024 aarch64 GNU/Linux
# Build cmd: docker build --no-cache . -t hustcer/nushell:latest
# Other tags: hustcer/nushell:0.98.0-debian
FROM debian:bookworm-slim

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/arm/armv7}
ARG ARCH=${ARCH/amd64/x86_64}
ARG ARCH=${ARCH/riscv64/riscv64gc}

ARG BUILD_REF
ARG BUILD_DATE
LABEL maintainer="hustcer <hustcer@outlook.com>" \
    org.opencontainers.image.authors="Nushell Team" \
    org.opencontainers.image.vendor="Nushell Project" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$BUILD_REF \
    org.opencontainers.image.title="Nushell Image Based on Alpine Linux" \
    org.opencontainers.image.description="A new type of shell" \
    org.opencontainers.image.documentation="https://nushell.sh" \
    org.opencontainers.image.source="https://github.com/nushell/nushell" \
    io.artifacthub.package.readme-url="https://raw.githubusercontent.com/nushell/nushell/refs/heads/main/README.md"

RUN echo '/usr/bin/nu' >> /etc/shells \
    && adduser --disabled-password --shell /usr/bin/nu --gecos "" nushell \
    && cd /tmp \
    && apt-get update && apt-get upgrade -y \
    && apt-get install apt-transport-https ca-certificates curl aria2 -y --no-install-recommends --no-install-suggests \
    && curl -s https://api.github.com/repos/nushell/nushell/releases/latest \
        | grep browser_download_url \
        | cut -d '"' -f 4 \
        | grep ${ARCH}-unknown-linux-gnu \
        | aria2c -i - \
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
