#!/bin/bash

set -e
set -o pipefail

if ! command -v parallel > /dev/null; then
  echo 'missing gnu parallel'
  echo 'sudo apt-get install parallel'
  exit 1
fi

if ! parallel --help | grep -q 'GNU Parallel'; then
  echo 'found parallel, but it is not gnu parallel'
  echo "\`sudo apt-get install parallel\` is the right package"
  exit 1
fi

TOTAL_EXECUTIONS="${1:-1000}"
CONCURRENT_JOBS="${2:-"$(( "$(nproc)" * 2 ))"}"

echo "TOTAL_EXECUTIONS: $TOTAL_EXECUTIONS" > /dev/stderr
echo "CONCURRENT_JOBS : $CONCURRENT_JOBS" > /dev/stderr

seq "$TOTAL_EXECUTIONS" | parallel -j"$CONCURRENT_JOBS" './run-vm.sh' | grep '\[urandomcollide-important\]'
