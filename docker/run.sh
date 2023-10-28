#!/usr/bin/env bash
set -ex
: ${SOURCE_DIR:?"SOURCE_DIR is not set or is empty"}
: ${WHEEL_DIR:?"WHEEL_DIR is not set or is empty"}

sudo -E docker run -u $(id -u):$(id -g) -e WHEEL_DIR=${WHEEL_DIR} -e SOURCE_DIR=${SOURCE_DIR} -v ${SOURCE_DIR}:${SOURCE_DIR} -w ${SOURCE_DIR} myapp-manylinux-env ${SOURCE_DIR}/docker/collect-fix-wheels.sh