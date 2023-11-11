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

sudo -E \
docker run -u $(id -u):$(id -g) \
-e WHEEL_DIR=${WHEEL_DIR} \
-e SOURCE_DIR=${SOURCE_DIR} \
-e BUILD_DIR=${BUILD_DIR} \
-e DIST_DIR=${DIST_DIR} \
-v ${CACHE_DIR}:/home/builder/.cache/ \
-v ${SOURCE_DIR}:${SOURCE_DIR} \
-w ${SOURCE_DIR} \
myapp-manylinux-build-env \
${1}