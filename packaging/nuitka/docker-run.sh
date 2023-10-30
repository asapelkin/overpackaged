#!/usr/bin/env bash
set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}


# -u $(id -u):$(id -g)
sudo -E \
docker run \
-e WHEEL_DIR=${WHEEL_DIR} \
-e BUILD_DIR=${BUILD_DIR} \
-v ${SOURCE_DIR}:${SOURCE_DIR}:ro \
-v ${WHEEL_DIR}:${WHEEL_DIR}:ro \
-v ${BUILD_DIR}:${BUILD_DIR}:rw \
-w ${SOURCE_DIR} \
myapp-manylinux-build-env \
${SOURCE_DIR}/packaging/nuitka/build.sh

cp ${BUILD_DIR}/myapp.nuitka ${DIST_DIR}/myapp.nuitka