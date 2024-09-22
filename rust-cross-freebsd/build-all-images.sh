#!/bin/bash -e
ARCH="x86_64"
RUST_RELEASE="1.81.0"

TAG="hustcer/rust-cross-freebsd:rust-${RUST_RELEASE}"
echo "${TAG}"
docker buildx build --progress tty \
                    --build-arg ARCH="${ARCH}" \
                    --build-arg RUST_RELEASE="${RUST_RELEASE}" \
                    --tag "${TAG}" .
docker image tag "hustcer/rust-cross-freebsd:latest"

