#!/bin/env bash
set -ex

: ${PYTHON_INSTALL_PREFIX:?"PYTHON_INSTALL_PREFIX is not set or is empty"}

scriptdir="$( dirname -- "$BASH_SOURCE"; )";

sudo -E docker build -t myapp-manylinux-build-env -f ${scriptdir}/Dockerfile.manylinux . --build-arg="PYTHON_INSTALL_PREFIX=${PYTHON_INSTALL_PREFIX}"