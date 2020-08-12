#!/bin/bash

set -e
set -o pipefail

exec qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -kernel vmlinuz-5.4.0-42-generic \
  -initrd urandomcollide-initrd \
  -m 64 \
  -nographic \
  -append 'console=ttyS0 quiet' # quiet makes it ~200ms faster