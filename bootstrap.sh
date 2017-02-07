#!/bin/sh

BOOST_ROOT_DIR=$1

cmake -E make_directory build
cmake -E chdir build cmake -E time cmake .. -DBOOST_ROOT=${BOOST_ROOT_DIR}

cmake --build build --target all --config Release --clean-first -- -j
