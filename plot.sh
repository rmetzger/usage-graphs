#!/bin/bash

##
#  Author: Robert Metzger <metzgerr@web.de>
#  https://github.com/rmetzger
##

INPUT=$1
OUTPUT=$2
TITLE=$3


sed -e 's/#INPUT#/'"$INPUT"'/' -e 's/#OUTPUT#/'"$OUTPUT"'/' -e 's/#TITLE#/'"$TITLE"'/' < ../plot.gnu > _gnuplot-in.tmp


gnuplot _gnuplot-in.tmp

rm "_gnuplot-in.tmp"

