#!/usr/env/bash

# Since FetchContent has some side effect, so we build it in shell.
# Download all
[ ! -f v2.2.2.zip ] && wget -c https://github.com/gflags/gflags/archive/v2.2.2.zip
unzip -o v2.2.2.zip
pushd gflags-2.2.2
cmake -B build -DGFLAGS_BUILD_SHARED_LIBS=ON -DGFLAGS_BUILD_STATIC_LIBS=OFF -DGFLAGS_BUILD_gflags_LIB=ON
cmake --build build
popd
