# syntax=docker/dockerfile:latest

# Nu: 0.100.0, Node: v20.18.0 LTS, npm: 10.8.2, pnpm: 9.12.3, Git: 2.39.2, fnm 1.37.1
# GNU bash: 5.2.15, Wget 1.21.3, aria2: 1.36.0, curl: 7.88.1, ripgrep 13.0.0, sd 1.0.0
# fd 10.2.0, ast-grep(sg) 0.30.0, just 1.36.0, ossutil v1.7.19
# /etc/os-release: Debian GNU/Linux 12 (bookworm)
# Kernel: Linux bdbfa1bb3a92 6.4.16-linuxkit #1 SMP PREEMPT_DYNAMIC Thu Nov 16 10:55:59 UTC 2023 x86_64 GNU/Linux
# Build cmd: docker build . -t hustcer/debian-nu:0.100-node.20.18-extra --no-cache
# docker buildx build --platform linux/amd64,linux/arm64 . -t hustcer/debian-nu:0.100-node.20.18-extra --no-cache
# Other tags: terminus/debian-nu:0.100-n20.18-extra,terminus/debian-nu:0.100-extra
FROM hustcer/debian-nu:0.100-node.20.18.lts

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/amd64/x86_64}

LABEL maintainer=hustcer<hustcer@outlook.com>

# Use mirrors to speed up installation
RUN apt-get update \
    && apt-get upgrade -y \
    # Install sg
    && pnpm install --global @ast-grep/cli \
    # Install fd
    && cd /lib; curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-unknown-linux-musl | aria2c -i - \
    && mkdir fd-latest && tar xvf fd-*.tar.gz --directory=fd-latest \
    && cp -aR fd-latest/**/fd* /usr/local/bin/ \
    # Install just
    && curl -s https://api.github.com/repos/casey/just/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-unknown-linux-musl | aria2c -i - \
    && mkdir just-latest && tar xvf just-*.tar.gz --directory=just-latest \
    && cp -aR just-latest/just* /usr/local/bin/ \
    # Install Ossutils
    && curl https://gosspublic.alicdn.com/ossutil/install.sh | bash \
    && rm -rf /var/lib/apt/lists/* && apt autoremove -y \
    && rm -rf just* fd*

CMD [ "nu" ]
