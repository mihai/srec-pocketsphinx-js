#!/bin/bash

CPROGR="test-static-inline"
# Test js compilation of simple C program that opens file with fopen
# 1. Compile with emcc
echo "-- Compiling with emcc ..."
emcc -O0 --closure 0 -s SAFE_HEAP=1 $CPROGR.c -o $CPROGR.js
echo "-- Compiling with gcc ..."
gcc -Wall $CPROGR.c -o $CPROGR
echo

# 2. Run with node
echo "-- Running compiled js ..."
node $CPROGR.js 
echo
echo "-- Running native ..."
./$CPROGR 
