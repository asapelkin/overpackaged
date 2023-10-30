#!/bin/bash
set -ex

: ${BUILD_DIR:?"BUILD_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

PYTHON_HOME="/opt/python/cp38-cp38/bin/"
export PATH=${PYTHON_HOME}:${PATH}
PYTHON="${PYTHON_HOME}/python"
PIP="${PYTHON_HOME}/pip"

${PYTHON} -m venv .venv
. .venv/bin/activate

${PIP} install myapp \
--no-index \
--find-links "${WHEEL_DIR}"

export LIBRARY_PATH=/opt/python/cp38-cp38/lib/
${PYTHON} -m nuitka \
--standalone \
$(which myapp) \
-o myapp.nuitka \
--output-dir=${BUILD_DIR} \
--lto=yes \
--python-flag=-O \
--experimental=use_peephole \
--experimental=use-staticmethod-nodes \
--onefile
