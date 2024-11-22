#!/bin/sh -ex

CLANG_TRIPLE="${ARCH}-unknown-freebsd${FREEBSD_RELEASE}"
RUSTC_TRIPLE="${ARCH}-unknown-freebsd"
FREEBSD_BASE="/usr/local/freebsd-${FREEBSD_RELEASE}"
BUILD_DEPENDENCIES="curl xz-utils"

export DEBIAN_FRONTEND=noninteractive
apt-get update
# shellcheck disable=SC2086
apt-get install -y --no-install-recommends ${BUILD_DEPENDENCIES}

# Create cross compile wrapper scripts for clang.
cat >> "/usr/bin/${CLANG_TRIPLE}-clang" <<EOF
#!/bin/sh
/usr/bin/clang --sysroot=${FREEBSD_BASE} "\$@" --target=${CLANG_TRIPLE}
EOF
cat >> "/usr/bin/${CLANG_TRIPLE}-clang++" <<EOF
#!/bin/sh
/usr/bin/clang++ --sysroot=${FREEBSD_BASE} "\$@" --target=${CLANG_TRIPLE}
EOF
chmod 755 "/usr/bin/${CLANG_TRIPLE}-clang" "/usr/bin/${CLANG_TRIPLE}-clang++"

groupadd -r rust -g 2000
useradd -m -r -g rust -u 2000 rust

install_artifact() {
    ARTIFACT=$1
    curl "${ARTIFACT}" | tar -x -J -f -
    DIR=$(basename "${ARTIFACT}" | sed 's/\.tar\.xz//')
    "${DIR}"/./install.sh --prefix=/home/rust/.x86_64-unknown-linux-gnu-patched/
    rm -fr "${DIR}"
}

curl https://sh.rustup.rs -sSf | su rust -c "sh -s -- --default-toolchain ${RUST_RELEASE} --profile minimal -y"
su rust -c ". /home/rust/.cargo/env; rustup target add ${RUSTC_TRIPLE}"

# Set the linker for Cargo.
su rust -c "cat >> /home/rust/.cargo/config.toml <<EOF
[target.${RUSTC_TRIPLE}]
linker = \"/usr/bin/${CLANG_TRIPLE}-clang\"
EOF"

# Script to set environment variables needed for cross compiling. This is useful to allow for running unit tests on
# the host before targeting the cross environment.
su rust -c "cat >> /home/rust/set-cross-compile-env.sh <<EOF
export CC_$(echo "${RUSTC_TRIPLE}" | sed s/-/_/g)=/usr/bin/${CLANG_TRIPLE}-clang
export CXX_$(echo "${RUSTC_TRIPLE}" | sed s/-/_/g)=/usr/bin/${CLANG_TRIPLE}-clang++
EOF"

# Fix the following potential error:
# error: component download failed for cargo-x86_64-unknown-linux-gnu: error opening file for download
chmod -R 777 /home/rust/.cargo
# Fix the following potential error:
# error: could not create temp file /home/rust/.rustup/tmp/8i35_4tuli9hx7cf_file: Permission denied (os error 13)
chmod -R 777 /home/rust/.rustup

rm /usr/bin/ld
ln -s /usr/bin/ld.lld /usr/bin/ld

# Cleanup
# shellcheck disable=SC2086
apt-get purge -y ${BUILD_DEPENDENCIES}
apt-get autoremove --purge -y
rm -f /tmp/cross-compile-setup.sh
