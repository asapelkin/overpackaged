#!/bin/bash
set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}

mkdir -p $BUILD_DIR

python -m nuitka \
--standalone \
$(which myapp) \
--onefile -o myapp \
--output-dir=${BUILD_DIR}

cp ${BUILD_DIR}/myapp ${DIST_DIR}/myapp