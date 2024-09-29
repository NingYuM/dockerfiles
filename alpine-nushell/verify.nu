#!/usr/bin/env nu

# REF:
#   - https://artifacthub.io/docs/topics/repositories/container-images/

# Use oras to login docker registry:
# oras login docker.io -u USERNAME -p PASSWORD

let ARGS = [
        docker.io/hustcer/nushell:artifacthub.io
        --config
        /dev/null:application/vnd.cncf.artifacthub.config.v1+yaml
        artifacthub-repo.yml:application/vnd.cncf.artifacthub.repository-metadata.layer.v1.yaml
    ]

oras push ...$ARGS
