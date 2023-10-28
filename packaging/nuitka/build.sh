#!/bin/bash
set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}

mkdir -p $BUILD_DIR

python -m nuitka \
--standalone \
$(which myapp) \
-o myapp.nuitka \
--output-dir=${BUILD_DIR} \
--lto=yes \
--python-flag=-O \
--experimental=use_peephole \
--experimental=use-staticmethod-nodes

cp ${BUILD_DIR}/myapp.nuitka ${DIST_DIR}/myapp.nuitka