#!/bin/bash

while getopts p:d:o:t:m: option
do
	case "${option}"
	in
	p) PROCS=${OPTARG};;
	d) INTERM=${OPTARG};;
	o) BT1=${OPTARG};;
	t) BT2=${OPTARG};;
	m) MANIFEST=${OPTARG};;
	esac
done

BASEDIR=$(dirname "$0")
mkdir $BASEDIR/top_logs
mkdir $BASEDIR/run_logs

# loop over all core counts
for CORES in $(echo $PROCS | tr "," "\n")
do
	echo Running 5 Rail instances with $CORES cores

	# start recording with top in background
	top -d 2 -b > $BASEDIR/top_logs/top_core_$CORES.log &
	TOPPID=$!

	# start 5 rail processes and send to background
	RAIL_PIDS = () # keep track of all rail pids
	for i in {1..5}
	do
		rail-rna go local -x $BT1 $BT2 -m $MANIFEST -p $CORES --scratch $INTERM &
		RAIL_PIDS+=($!) # keep track of all rail pids
	done

	# wait for all rail instances to finish
	for rail_pid in ${RAIL_PIDS[@]}
	do
		wait $rail_pid
	done


	# kill background top
	kill $TOPPID

	cp $BASEDIR/rail-rna_logs/*.log $BASEDIR/run_logs/$CORES/
	rm -rf $BASEDIR/rail-rna_logs/
	rm -rf $BASEDIR/rail-rna_out/
done
