#!/bin/bash

##
#  Author: Robert Metzger <metzgerr@web.de>
#  https://github.com/rmetzger
##

INPUT=$1
OUTPUT=$2
TITLE=$3

#script=$(cat plot.gnu | sed 's/"/\\"/g' )

#script=$(cat plot.gnu)
#script=${script//#INPUT#/INPUT}
#echo  -n $script > _gnuplot-in.tmp

gnuplot _gnuplot-in.tmp

#rm "_gnuplot-in.tmp"

