#!/bin/bash

: ${DIST_DIR:?"DIST_DIR is not set or is empty"}
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

declare -a images=(
  "ubuntu:17.04"
  "ubuntu:18.04"
  "ubuntu:20.04"
  "opensuse/leap:15.0"
  "debian:9"
  "debian:10"
)

declare -a executables=(
  "myapp_nuitka_onefile"
  "myapp_nuitka_as_folder/myapp"
  "pyoxidizer/myapp"
)

success_count=0
error_count=0

for image in "${images[@]}"; do
  for executable in "${executables[@]}"; do
    echo "Testing ${executable} on ${image}..."

    if sudo -E docker run --rm -v "${DIST_DIR}:/myapp:ro" "${image}" /myapp/${executable} > /dev/null 2>&1; then
      echo "Success: ${executable} passed on ${image}"
      ((success_count++))
    else
      echo "Error: ${executable} failed on ${image}"
      ((error_count++))
    fi
  done
done

total_tests=$((success_count + error_count))
echo "Total tests run: ${total_tests}"
echo "Successes: ${success_count}"
echo "Failures: ${error_count}"

exit ${error_count}