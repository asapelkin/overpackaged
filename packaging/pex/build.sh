#!/bin/bash
set -ex

: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}

mkdir -p $BUILD_DIR

pex ${SOURCE_DIR} \
-c myapp \
--compile \
--output-file ${DIST_DIR}/myapp.pex \
--interpreter-constraint "CPython>=3.8" \
--pex-root ${BUILD_DIR}/.work-dir