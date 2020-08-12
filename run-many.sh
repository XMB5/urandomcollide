#!/bin/bash

set -e
set -o pipefail

TOTAL_EXECUTIONS="${1:-1000}"
CONCURRENT_JOBS="${2:-"$(( "$(nproc)" * 2 ))"}"

echo "TOTAL_EXECUTIONS: $TOTAL_EXECUTIONS" > /dev/stderr
echo "CONCURRENT_JOBS : $CONCURRENT_JOBS" > /dev/stderr

seq "$TOTAL_EXECUTIONS" | parallel -j"$CONCURRENT_JOBS" './run-vm.sh' | grep '\[urandomcollide-important\]'
