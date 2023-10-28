#!/bin/bash
set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}

mkdir -p $BUILD_DIR
mkdir -p $DIST_DIR

cd ${BUILD_DIR}
export PIP_FIND_LINKS=${WHEEL_DIR}
export PIP_NO_INDEX=1
python-appimage --verbose build app \
${SOURCE_DIR}/packaging/appimage/package \
--python-tag cp38-cp38   \
--linux-tag manylinux1_x86_64 \
--python-version 3.8

cp ${BUILD_DIR}/package-x86_64.AppImage ${DIST_DIR}/myapp.AppImage
