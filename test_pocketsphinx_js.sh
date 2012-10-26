#!/bin/bash

JS_DIR=js

# Running pocketsphinx_continuous.js
echo "-- Running pocketsphinx_continuous.js ..."
node $JS_DIR/pocketsphinx_continuous.js -infile test/data/numbers.raw \
	-hmm model/hmm/en/tidigits \
	-dict model/lm/en/tidigits.dic \
	-lm model/lm/en/tidigits.DMP
