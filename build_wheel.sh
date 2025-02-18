#!/usr/bin/sh

# This script will build a manylinux_2_28 wheel if used in the
# manylinux_2_28_x86_64 container:
#
# docker run --rm -v $(pwd):/mnt -w /mnt quay.io/pypa/manylinux_2_28_x86_64 /mnt/build_wheel.sh

# Install rust
curl --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
source $HOME/.cargo/env

# Build the wheels, we only need to build one
for PYBIN in /opt/python/cp311-*/bin; do
    "${PYBIN}/pip" install maturin uniffi-bindgen
    "${PYBIN}/maturin" build --release --manylinux 2_28
done

# Build just for python 3.11
PATH=/opt/python/cp311-cp311/bin:$PATH
export PATH

# Install our build tools
pip install maturin uniffi-bindgen

# Build the wheel
maturin build --release --manylinux 2_28
