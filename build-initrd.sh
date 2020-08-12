#!/bin/bash

set -e
set -o pipefail

mkdir tmp-initrd
cp urandomcollide tmp-initrd/init
cd tmp-initrd
echo 'init' | cpio --format newc -o | gzip > ../urandomcollide-initrd
cd ..
rm -rf tmp-initrd