#!/bin/bash

# Script used to compile and run the JavaScript version of the 
# pocketsphinx_continuous program
# -------------------------------
# Mihai Cirlanaru

SPHINXBASE_DIR=../sphinxbase-0.7
# NOTE! You must also compile sphinxbase with emcc before running this script

JS_DIR=js
JS_PROGR=pocketsphinx_continuous.js

RAW_FILE=test/data/numbers.raw

# Acoustic and language models parameters
HMM_DIR=model/hmm/en/tidigits # Tidigits acoustic model
LM_DIR=model/lm/en
DICT=tidigits.dic
DMP=tidigits.DMP
FSG=tidigits.fsg


POCKETSPHINX_ROOT=.
ARGS="-O2 --closure 0"
ARGS_SAFE="-O0 --closure 0 -s SAFE_HEAP=1" 
cd $POCKETSPHINX_ROOT

echo "-- Compiling $JS_PROGR with emcc ... (takes a while)"
emcc $ARGS \
	src/libpocketsphinx/.libs/*.o src/libpocketsphinx/.libs/libpocketsphinx.a \
	$SPHINXBASE_DIR/src/libsphinxbase/.libs/libsphinxbase.a \
	$SPHINXBASE_DIR/src/libsphinxad/.libs/libsphinxad.a \
	$SPHINXBASE_DIR/src/libsphinxad/*.o \
	src/programs/continuous.o \
	--embed-file $RAW_FILE \
	--embed-file $HMM_DIR/mdef \
	--embed-file $HMM_DIR/transition_matrices \
	--embed-file $HMM_DIR/variances \
	--embed-file $HMM_DIR/sendump \
	--embed-file $HMM_DIR/feat.params \
	--embed-file $HMM_DIR/means \
	--embed-file $LM_DIR/$DMP \
	--embed-file $LM_DIR/$DICT \
	--embed-file $LM_DIR/$FSG \
	-o $JS_DIR/$JS_PROGR

echo "-- Running $JS_PROGR on $RAW_FILE ..."
node $JS_DIR/$JS_PROGR -infile $RAW_FILE \
	-hmm $HMM_DIR \
	-dict $LM_DIR/$DICT \
	-lm $LM_DIR/$DMP

