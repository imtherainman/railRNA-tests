#!/bin/bash

while getopts p:d:o:t:m:n: option
do
	case "${option}"
	in
	p) PROCS=${OPTARG};;
	d) INTERM=${OPTARG};;
	o) BT1=${OPTARG};;
	t) BT2=${OPTARG};;
	m) MANIFEST=${OPTARG};;
	n) NUMRAILS=${OPTARG};;
	esac

# BASEDIR=$(dirname "$0")
BASEDIR=/home1/05096/rcao/testing/parallel_logs/logs_$NUMRAILS_rail
mkdir $BASEDIR
mkdir $BASEDIR/top_logs_parallel
mkdir $BASEDIR/tmp_usage_logs_parallel

# loop over all core counts
for CORES in $(echo $PROCS | tr "," "\n")
do
	echo Running $NUMRAILS Rail instances with $CORES cores

	# start recording with top in background
	top -d 2 -b > $BASEDIR/top_logs_parallel/top_core_$CORES.log &
	TOPPID=$!

	# start tracking tmp usage in background
	while true ; do df /tmp >> $BASEDIR/tmp_usage_logs_parallel/tmp_usage_$CORES.log ; sleep 1 ; done &
	DFTMPPID=$!

	# start NUMRAILS rail processes and send to background
	RAIL_PIDS=() # keep track of all rail pids
	for i in {1..$NUMRAILS}
	do
		rail-rna go local -x $BT1 $BT2 -m $MANIFEST -p $CORES --scratch $INTERM --output $BASEDIR/rail-rna_out_$i --log ./rail-rna_logs_$i &
		RAIL_PIDS+=($!) # keep track of all rail pids
	done

	# wait for all rail instances to finish
	for rail_pid in ${RAIL_PIDS[@]}
	do
		wait $rail_pid
	done


	# kill background top
	kill $TOPPID

	# kill df tmp
	kill $DFTMPPID

	#cp $BASEDIR/rail-rna_logs/*.log $BASEDIR/run_logs_parallel/$CORES/
	#rm -rf $BASEDIR/rail-rna_logs/
	#rm -rf $BASEDIR/rail-rna_out/
done
