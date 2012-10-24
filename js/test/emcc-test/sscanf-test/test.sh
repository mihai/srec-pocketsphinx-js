#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: `basename $0` file"
  exit 1
fi

CPROGR="test-sscanf"
FILE=$1
# Test js compilation of simple C program that opens file with fopen
# 1. Compile with emcc
echo "-- Compiling with emcc ..."
emcc -O0 --closure 0 -s SAFE_HEAP=1 --embed-file $FILE $CPROGR.c -o $CPROGR.js
echo "-- Compiling with gcc ..."
gcc -Wall $CPROGR.c -o $CPROGR
echo

# 2. Run with node
echo "-- Running compiled js ..."
node $CPROGR.js $FILE
echo
echo "-- Running native ..."
./$CPROGR $FILE

