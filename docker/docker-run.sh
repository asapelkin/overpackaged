#!/usr/bin/env bash
set -ex

: ${1:?"scripts path is not provided or is empty"}
: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${CACHE_DIR:?"CACHE_DIR is not set or is empty"}

mkdir -p ${BUILD_DIR}
mkdir -p ${DIST_DIR}
mkdir -p ${CACHE_DIR}
mkdir -p ${CACHE_DIR}/cargo

sudo -E \
docker run -u $(id -u):$(id -g) \
-e WHEEL_DIR=${WHEEL_DIR} \
-e SOURCE_DIR=${SOURCE_DIR} \
-e BUILD_DIR=${BUILD_DIR} \
-e DIST_DIR=${DIST_DIR} \
-e MANYLINUX_PYTHON=${MANYLINUX_PYTHON} \
-e MANYLINUX_PIP=${MANYLINUX_PIP} \
-e PYTHON_INSTALL_PREFIXT_DIR=${PYTHON_INSTALL_PREFIX} \
-e PYTHON_HOME=${PYTHON_HOME} \
-e PYTHON=${PYTHON} \
-e PIP=${PIP} \
-v ${CACHE_DIR}:/home/builder/.cache/ \
-v ${CACHE_DIR}/cargo:/home/builder/.cargo/ \
-v ${SOURCE_DIR}:${SOURCE_DIR} \
-w ${SOURCE_DIR} \
myapp-manylinux-build-env \
${1}