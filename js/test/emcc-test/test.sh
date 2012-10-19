#!/bin/bash

# Test js compilation of simple C program that opens file with fopen
# 1. Compile with emcc
echo "-- Compiling with emcc ..."
emcc -O2 --closure 0 --embed-file model/hmm/en/tidigits/mdef hello_world.c -o hello_world.js
# 2. Run with node
echo "-- Running compiled js ..."
node hello_world.js model/hmm/en/tidigits/mdef
