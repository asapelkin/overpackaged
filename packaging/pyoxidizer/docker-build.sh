#!/bin/bash
set -ex

: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}

mkdir -p $DIST_DIR

export PIP_FIND_LINKS=${WHEEL_DIR}
export PIP_NO_INDEX=1
pyoxidizer build --release --path ${SOURCE_DIR}/packaging/pyoxidizer

INSTALL_DIR=${SOURCE_DIR}/packaging/pyoxidizer/build/*/release/install
mkdir ${DIST_DIR}/pyoxidizer
cp -r ${INSTALL_DIR}/lib ${DIST_DIR}/pyoxidizer/lib
cp ${INSTALL_DIR}/myapp ${DIST_DIR}/pyoxidizer/myapp
