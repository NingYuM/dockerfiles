# Build Stage
FROM silkeh/clang:18 AS builder

# Required by the setup-cross-compile and install-freebsd scripts.
ARG ARCH=x86_64
ARG RUST_RELEASE=1.81.0
# Arbitrary versions aren't supported, but might still work.
ARG FREEBSD_RELEASE=13.4

COPY install-freebsd.sh setup-cross-compile.sh /tmp/

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /tmp/install-freebsd.sh \
    && /tmp/setup-cross-compile.sh \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Final Stage
FROM debian:bookworm-slim

ARG FREEBSD_RELEASE=13.4

RUN apt-get update && apt-get upgrade -y \
    && apt-get install apt-transport-https ca-certificates -y --no-install-recommends --no-install-suggests \
    && rm -rf /var/lib/apt/lists/* && apt autoremove -y \
    && useradd -m rust

USER rust
COPY --from=builder /usr/bin/ /usr/bin/
COPY --from=builder /usr/lib/ /usr/lib/
COPY --from=builder /home/rust /home/rust
COPY --from=builder /usr/local/freebsd-${FREEBSD_RELEASE} /usr/local/freebsd-${FREEBSD_RELEASE}
COPY docker-entrypoint.sh /home/rust/

ENV PATH="/home/rust/.cargo/bin:${PATH}" \
    OPENSSL_DIR=/usr/local/freebsd-${FREEBSD_RELEASE}/usr

WORKDIR /src
ENTRYPOINT ["/home/rust/docker-entrypoint.sh"]
CMD ["help"]
