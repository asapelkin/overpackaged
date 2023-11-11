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
mkdir -p $BUILD_DIR
cd ${BUILD_DIR}

export PATH=${PYTHON_HOME}/bin:${PATH}:${HOME}/.local/bin

${PYTHON} -m pex myapp \
-e myapp.myapp:cli \
--no-pypi --no-index \
-f ${WHEEL_DIR}  \
--compile \
--output-file ${DIST_DIR}/myapp.pex \
--interpreter-constraint "CPython==3.8.16" \
--python ${PYTHON} \
--pex-root ${BUILD_DIR}/.work-dir
