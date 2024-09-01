# syntax=docker/dockerfile:latest

# version   : "2.2.0"
# title     : hustcer/crowbook
# author    : "Justin Ma" <hustcer@outlook.com>
# Build cmd : docker build . -t hustcer/crowbook -f Dockerfile
# Other tags: hustcer/crowbook:v2.2
FROM hustcer/xelatex:latest

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/amd64/x86_64}

LABEL version="2.2.0"
LABEL title="hustcer/crowbook"
LABEL authors="hustcer <hustcer@outlook.com>"

# Use mirrors to speed up installation
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install aria2 curl xz-utils zip -y --no-install-recommends --no-install-suggests \
  # Make /bin/sh symlink to bash instead of dash:
  # REF: https://groups.google.com/g/linux.debian.user/c/2CyfM5UrSOI?pli=1
  && dpkg-divert --remove --no-rename /usr/share/man/man1/sh.1.gz \
  && dpkg-divert --remove --no-rename /bin/sh \
  && ln -sf bash.1.gz /usr/share/man/man1/sh.1.gz \
  && ln -sf bash /bin/sh \
  && dpkg-divert --add --local --no-rename /usr/share/man/man1/sh.1.gz \
  && dpkg-divert --add --local --no-rename /bin/sh \
  # Install and setup Nushell
  && cd /lib && curl -s https://api.github.com/repos/nushell/nushell/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-unknown-linux-gnu | aria2c -i - \
  && mkdir nu-latest && tar xvf nu-*.tar.gz --directory=nu-latest \
  && cp -aR nu-latest/**/* /usr/local/bin/ && mkdir -p /root/.config/nushell && nu -c 'config reset -w' \
  && cd /lib; rm -rf nu-* \
  # Install and setup Helix
  && curl -s https://api.github.com/repos/helix-editor/helix/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep ${ARCH}-linux | aria2c -i - \
  && tar -xf helix*.tar.xz && cp -aR helix-*-linux/* /usr/local/bin/; rm -rf /lib/helix* \
  # Install and setup Crowbook
  # && aria2c https://github.com/hustcer/crowbook/releases/download/0.16.3/crowbook-0.17.0-x86_64-unknown-linux-gnu.tar.gz \
  && curl -s https://api.github.com/repos/hustcer/crowbook/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep linux-gnu | aria2c -i - \
  && tar -xvf crowbook-*.tar.gz && cp crowbook-*-linux-gnu/* /usr/local/bin/; rm -rf /lib/crowbook* \
  && rm -rf /var/lib/apt/lists/* && apt autoremove -y
