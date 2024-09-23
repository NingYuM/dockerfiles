#!/bin/sh -ex

FREEBSD_BASE="/usr/local/freebsd-${FREEBSD_RELEASE}"
BUILD_DEPENDENCIES="curl xz-utils"

# Determine the arch for downloading the FreeBSD base system.
case ${ARCH} in
"x86_64") RELEASE_ARCH="amd64";;
*) echo "Invalid architecture: ${ARCH}"; exit 1;;
esac

export DEBIAN_FRONTEND=noninteractive
apt-get update
# shellcheck disable=SC2086
apt-get install -y --no-install-recommends ${BUILD_DEPENDENCIES}

# Extract needed includes and libs from the FreeBSD base package.
mkdir "${FREEBSD_BASE}"
# http://ftp-archive.freebsd.org/pub/FreeBSD-Archive/old-releases/amd64/12.2-RELEASE/base.txz
curl -L "https://download.freebsd.org/ftp/releases/${RELEASE_ARCH}/${FREEBSD_RELEASE}-RELEASE/base.txz" \
  | tar -x -J -C "${FREEBSD_BASE}" ./usr/include ./usr/lib ./lib -f -

# Cleanup
# shellcheck disable=SC2086
apt-get purge -y ${BUILD_DEPENDENCIES}
apt-get autoremove --purge -y
rm -f /tmp/install-freebsd.sh
