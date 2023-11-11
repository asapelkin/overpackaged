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

NUITKA_FLAGS="--jobs=$(nproc --all) \
--output-dir=${BUILD_DIR} \
--lto=yes \
--python-flag=-O \
--standalone"

${PYTHON} -m nuitka \
$(which myapp) \
-o myapp_nuitka_onefile \
${NUITKA_FLAGS} \
--onefile

${PYTHON} -m nuitka \
$(which myapp) \
-o myapp \
${NUITKA_FLAGS}

cp ${BUILD_DIR}/myapp_nuitka_onefile ${DIST_DIR}/myapp_nuitka_onefile
cp -r ${BUILD_DIR}/myapp.dist ${DIST_DIR}/myapp_nuitka_as_folder

# TODO link to python staticaly
# export CC=clang-14
# --static-libpython=yes
# export LDFLAGS="-L/opt/python-build-standalone/python/build/lib/ -L/opt/python-build-standalone/python/install/lib/   -fuse-ld=lld-14 -static -lncursesw -lpanelw -lbz2 -lgdbm -ledit    -lformw_g       -lhistory   -lmenuw_g      -lpanelw     -lsqlite3   -ltclstub8.6   -luuid   -lxcb   -lcrypto     -llzma      -lncursesw     -lpanelw_g   -lssl       -ltk8.6        -lX11    -lz   -ldb       -lformw   -lgdbm_compat   -lmenuw     -lncursesw_g   -ltcl8.6    -ltkstub8.6    -lXau    "
