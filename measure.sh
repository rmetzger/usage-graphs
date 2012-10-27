#!/bin/bash

##
#  Author: Robert Metzger <metzgerr@web.de>
#  https://github.com/rmetzger
##



PROG=$1
DST=`date '+%s'`"-"$PROG".csv"

function usage {
	echo "USAGE: "
	echo "	measureCPU.sh <Pattern of process>"
	exit 1
}

if [ ! -d "results" ]; then
	mkdir results
fi
cd results

if [ -z "$PROG" ]; then
	usage
fi
echo "Measuring CPU for program matching '$PROG'"

# 1. Step: Find PID of application by waiting till the process exists
while [ true ]; do
	PID=`pgrep -f $PROG`
	# remove own pid from PID-var
	# $$ contains own pid
	# ${string//substring/replacement}
	PID=${PID//$$/}
	if [[ "$PID" =~ [0-9]+ ]]; then
		echo "Identified PID: $PID"
		break
	fi
	sleep 0.5
done


# returns cpu utilisation in percent
function probe_cpu {
	# top
	#	-n 1 only one execution
	#	-b batch mode (no curses interface)
	#	-p <pid>
	top -n 1 -b -p $1 | tail -n 1 | grep -o '[0-9]\+\.[0-9]' | head -n1
}

function probe_io {
	# PID BASED IOTOP_IN=`tail -n1 /tmp/iotop.measure | tr -s [:space:] `
	IOTOP_IN=`cat /tmp/iotop.measure | grep -v measure.sh | grep $PROG | tail -n1 | tr -s [:space:] `
	# echo "++"$IOTOP_IN"++"
	IO_READ=`echo $IOTOP_IN | cut -f 4 --delimiter=' '`
	IO_WRITE=`echo $IOTOP_IN | cut -f 6 --delimiter=' '`
	echo $IO_READ";"$IO_WRITE
}

function end {
	sudo kill $IOTOP_PID
	rm /tmp/iotop.measure
  	echo "Generating Plot"
  	../plot.sh $DST $DST "IO and CPU Results"
}

# generate statistics when user quits loop!
trap end EXIT

echo "Starting measurement (Stop with CTRL+C)"
# start iotop in background
# -p $PID 
sudo iotop -qqq --kilobytes --processes -d 1 --batch > /tmp/iotop.measure &
IOTOP_PID=$!

echo "iotop started with pid $IOTOP_PID"


TIME=0
while [ true ]; do
	CPU=$(probe_cpu $PID)
	echo $TIME";"$CPU";"$(probe_io $PID) | tee -a $DST
	
	# detect when a process dies
	if [ -z $CPU ] ; then
		break
	fi
	let TIME++
	sleep 1
done

