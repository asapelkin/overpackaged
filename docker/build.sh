#!/bin/env bash
set -ex

scriptdir="$( dirname -- "$BASH_SOURCE"; )";

sudo -E docker pull quay.io/pypa/manylinux2014_x86_64:2023-10-30-2d1b8c5
sudo -E docker build -t myapp-manylinux-build-env --network=host -f ${scriptdir}/Dockerfile.manylinux .