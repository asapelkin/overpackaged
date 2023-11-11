#!/usr/bin/env bash

# Check each wheel in WHEEL_DIR and repair
# the bad ones (that doesn't have `manylinux` or `any` tags)

set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}
: ${MANYLINUX_PIP:?"MANYLINUX_PIP is not set or is empty"}

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

rm -rf ${WHEEL_DIR}/*
${MANYLINUX_PIP} wheel ${SOURCE_DIR} -w ${WHEEL_DIR}
mkdir ${WHEEL_DIR}/to_fix
mv ${WHEEL_DIR}/*linux* ${WHEEL_DIR}/to_fix/
auditwheel repair --strip --wheel-dir ${WHEEL_DIR} ${WHEEL_DIR}/to_fix/*linux*
rm -rf ${WHEEL_DIR}/to_fix/
