#!/bin/bash
set -ex

: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}
: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}

mkdir -p $DIST_DIR
mkdir -p $BUILD_DIR
cd ${BUILD_DIR}

PYTHON_HOME="/opt/python-build-standalone/python/install/"
export PATH=${PYTHON_HOME}/bin:${PATH}:${HOME}/.local/bin
PYTHON="${PYTHON_HOME}/bin/python3"
PIP="${PYTHON_HOME}/bin/pip"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${PYTHON_HOME}/lib/"

${PYTHON} -m venv .venv
. .venv/bin/activate

${PIP} install myapp \
--no-index \
--find-links "${WHEEL_DIR}"

export PIP_FIND_LINKS=${WHEEL_DIR}
export PIP_NO_INDEX=1
${PYTHON} -m python_appimage --verbose build app \
${SOURCE_DIR}/packaging/appimage/package \
--python-tag cp38-cp38   \
--linux-tag manylinux_2_24_x86_64 \
--python-version 3.8

cp ${BUILD_DIR}/package-x86_64.AppImage ${DIST_DIR}/myapp.AppImage
