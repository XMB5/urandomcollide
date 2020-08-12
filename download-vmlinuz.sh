#!/bin/bash

set -e
set -o pipefail

mkdir tmp-vmlinuz
cd tmp-vmlinuz
wget 'http://security.ubuntu.com/ubuntu/pool/main/l/linux-signed/linux-image-5.4.0-42-generic_5.4.0-42.46_amd64.deb' -O linux.deb
sha256sum -c <<< '59f4a2dc220bd201a1eb8cd32f3e97f4bd5783a696c5eb8c48bd4d97fce5c25b linux.deb'
ar x linux.deb
tar xfv data.tar.xz
mv ./boot/vmlinuz-5.4.0-42-generic ..
cd ..
rm -rf tmp-vmlinuz