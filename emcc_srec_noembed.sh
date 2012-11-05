#!/bin/bash

# Script used to compile and run the JavaScript version of the 
# pocketsphinx_continuous program
# -------------------------------
# Mihai Cirlanaru

SPHINXBASE_DIR=../sphinxbase-0.7
# NOTE! You must also compile sphinxbase with emcc before running this script

JS_DIR=js
JS_PROGR=srec_min.js
PREJS=$JS_DIR/pre.js

POCKETSPHINX_ROOT=.
ARGS="-O2"
cd $POCKETSPHINX_ROOT

echo "-- Compiling $JS_PROGR with emcc ... (takes a while)"
emcc $ARGS \
	src/libpocketsphinx/.libs/*.o src/libpocketsphinx/.libs/libpocketsphinx.a \
	$SPHINXBASE_DIR/src/libsphinxbase/.libs/libsphinxbase.a \
	$SPHINXBASE_DIR/src/libsphinxad/.libs/libsphinxad.a \
	$SPHINXBASE_DIR/src/libsphinxad/*.o \
	src/programs/srec_file.o \
	-o $JS_DIR/$JS_PROGR \
  --pre-js $PREJS

