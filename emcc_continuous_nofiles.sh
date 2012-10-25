#!/bin/bash

# Script used to compile and run the JavaScript version of the 
# pocketsphinx_continuous program
# -------------------------------
# Mihai Cirlanaru

SPHINXBASE_DIR=../sphinxbase-0.7
# NOTE! You must also compile sphinxbase with emcc before running this script

JS_DIR=js
POCKETSPHINX_ROOT=.

cd $POCKETSPHINX_ROOT

echo "-- Compiling with emcc ... (takes a while)"
emcc -O2 --closure 0 \
	src/libpocketsphinx/.libs/*.o src/libpocketsphinx/.libs/libpocketsphinx.a \
	$SPHINXBASE_DIR/src/libsphinxbase/.libs/libsphinxbase.a \
	src/programs/continuous.o \
	-o $JS_DIR/pocketsphinx_continuous_nofiles.js

echo "-- Running pocketsphinx_continuous.js on numbers.raw ..."
node $JS_DIR/pocketsphinx_continuous_nofiles.js -infile test/data/numbers.raw \
	-hmm model/hmm/en/tidigits \
	-dict model/lm/en/tidigits.dic \
	-lm model/lm/en/tidigits.DMP

