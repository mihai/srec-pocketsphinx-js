#!/bin/bash

# Script used to compile and run the JavaScript version of the 
# pocketsphinx_continuous program
# -------------------------------
# Mihai Cirlanaru

SPHINXBASE_DIR=../sphinxbase-0.7
# NOTE! You must also compile sphinxbase with emcc before running this script

JS_DIR=js
POCKETSPHINX_ROOT=.
ARGS="-O2"
ARGS_SAFE="-O0 --closure 0 -s SAFE_HEAP=1" 
cd $POCKETSPHINX_ROOT

echo "-- Compiling with emcc ... (takes a while)"
emcc $ARGS \
	src/libpocketsphinx/.libs/*.o src/libpocketsphinx/.libs/libpocketsphinx.a \
	$SPHINXBASE_DIR/src/libsphinxbase/.libs/libsphinxbase.a \
	$SPHINXBASE_DIR/src/libsphinxad/.libs/libsphinxad.a \
	$SPHINXBASE_DIR/src/libsphinxad/*.o \
	src/programs/continuous.o \
	--embed-file test/data/numbers.raw \
	--embed-file model/hmm/en/tidigits/mdef \
	--embed-file model/hmm/en/tidigits/transition_matrices \
	--embed-file model/hmm/en/tidigits/variances \
	--embed-file model/hmm/en/tidigits/sendump \
	--embed-file model/hmm/en/tidigits/feat.params \
	--embed-file model/hmm/en/tidigits/means \
	--embed-file model/lm/en/tidigits.DMP \
	--embed-file model/lm/en/tidigits.dic \
	--embed-file model/lm/en/tidigits.fsg \
	-o $JS_DIR/pocketsphinx_continuous.js

echo "-- Running pocketsphinx_continuous.js on numbers.raw ..."
node $JS_DIR/pocketsphinx_continuous.js -infile test/data/numbers.raw \
	-hmm model/hmm/en/tidigits \
	-dict model/lm/en/tidigits.dic \
	-lm model/lm/en/tidigits.DMP

