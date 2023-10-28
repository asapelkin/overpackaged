#!/bin/env bash
set -ex

scriptdir="$( dirname -- "$BASH_SOURCE"; )";

docker pull quay.io/pypa/manylinux2014_x86_64:latest
docker pull docker:latest
docker build -t debian-fuse  --network=host -f ${scriptdir}/Dockerfile.fuse .
docker build -t myapp-manylinux-env --network=host -f ${scriptdir}/Dockerfile.manylinux .
