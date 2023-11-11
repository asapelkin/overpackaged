#!/bin/bash
set -ex

: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}
: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${PYTHON_HOME:?"PYTHON is not set or is empty"}
: ${PYTHON:?"PYTHON is not set or is empty"}
: ${PIP:?"PIP is not set or is empty"}

mkdir -p $DIST_DIR

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$(PYTHON_HOME)/lib/"
export PATH=${PYTHON_HOME}/bin:${PATH}:${HOME}/.local/bin
export PIP_FIND_LINKS=${WHEEL_DIR}
export PIP_NO_INDEX=1

export CARGO_BUILD_JOBS=$(nproc --all)
pyoxidizer build --release --path ${SOURCE_DIR}/packaging/pyoxidizer

INSTALL_DIR=${SOURCE_DIR}/packaging/pyoxidizer/build/*/release/install
mkdir -p ${DIST_DIR}/pyoxidizer
cp -r ${INSTALL_DIR}/lib ${DIST_DIR}/pyoxidizer/lib
cp ${INSTALL_DIR}/myapp ${DIST_DIR}/pyoxidizer/myapp
