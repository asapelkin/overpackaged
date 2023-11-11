#!/usr/bin/env bash
set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}

cd ${BUILD_DIR}

rm -rf ${WHEEL_DIR}/*
PYCURL_SSL_LIBRARY=nss /opt/python/cp38-cp38/bin/pip wheel ${SOURCE_DIR} -w ${WHEEL_DIR}
mkdir ${WHEEL_DIR}/to_fix
mv ${WHEEL_DIR}/*linux* ${WHEEL_DIR}/to_fix/  # TODO ugly
auditwheel repair --strip --wheel-dir ${WHEEL_DIR} ${WHEEL_DIR}/to_fix/*linux*
rm -rf ${WHEEL_DIR}/to_fix/
