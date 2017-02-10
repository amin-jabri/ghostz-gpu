#!/bin/sh

BOOST_ROOT_DIR=$1

# checkout googletest submodule
cmake -E time git submodule update --init --recursive
# out-of-source build
cmake -E make_directory build
cmake -E chdir build cmake -E time cmake .. -DBOOST_ROOT=${BOOST_ROOT_DIR}
# make all
cmake --build build --target all --config Release --clean-first -- -j
