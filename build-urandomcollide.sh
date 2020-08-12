#!/bin/bash

set -e
set -o pipefail

mkdir tmp-build
cd tmp-build
cmake ..
make -j"$(nproc)"
mv urandomcollide ..
cd ..
rm -rf tmp-build