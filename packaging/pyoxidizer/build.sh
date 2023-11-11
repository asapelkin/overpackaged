#!/bin/bash
set -ex

: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}

mkdir -p $DIST_DIR

PYTHON_HOME="/opt/python-build-standalone/python/install/"
export PATH=${PYTHON_HOME}/bin:${PATH}:${HOME}/.local/bin
PYTHON="${PYTHON_HOME}/bin/python3"
PIP="${PYTHON_HOME}/bin/pip"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${PYTHON_HOME}/lib/"


export PIP_FIND_LINKS=${WHEEL_DIR}
export PIP_NO_INDEX=1

export CARGO_BUILD_JOBS=$(nproc --all)
pyoxidizer build --release --path ${SOURCE_DIR}/packaging/pyoxidizer

INSTALL_DIR=${SOURCE_DIR}/packaging/pyoxidizer/build/*/release/install
mkdir -p ${DIST_DIR}/pyoxidizer
cp -r ${INSTALL_DIR}/lib ${DIST_DIR}/pyoxidizer/lib
cp ${INSTALL_DIR}/myapp ${DIST_DIR}/pyoxidizer/myapp
