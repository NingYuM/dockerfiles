# Docker Rust FreeBSD Target ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/hustcer/rust-cross-freebsd)

This Docker image is used to cross compile Rust for FreeBSD.

## Usage

### General Example
In the directory containing your project run:
```shell
    docker container run --rm --volume "$(pwd)":/src     \
        --init --tty --user "$(id --user):$(id --group)" \
        "hustcer/rust-cross-freebsd:latest"      \
        build --release --target x86_64-unknown-freebsd
```

### GitHub Action Example
This example works out of the box in a run step with the ubuntu runner.
```shell
    docker container run --rm
        --volume ${{ github.workspace }}:/src
        --user $(id --user):$(id --group)
        hustcer/rust-cross-freebsd:latest build --release --target x86_64-unknown-freebsd
```

### Using as a Base Image
```dockerfile
FROM hustcer/rust-cross-freebsd:latest
USER root
RUN apt-get update \
    && apt-get install --no-install-recommends -y libssl-dev
USER rust
ENTRYPOINT ["/bin/sh", "-c"]
```

## Docker Hub
* [x86_64](https://hub.docker.com/r/hustcer/rust-cross-freebsd)

## Building
There are two optional build args:
* `ARCH`: The target architecture (x86_64). Default is x86_64.
* `RUST_RELEASE`: The release of Rust to install. Check `Dockerfile` for the default.

### x86_64
```shell
docker buildx build --tag rust-cross-freebsd .
```

