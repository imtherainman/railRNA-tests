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

# loop over all core counts
for CORES in $(echo $PROCS | tr "," "\n")
do
  echo Running Rail with $CORES processes
  rail-rna go local -x $BT1 $BT2 -m $MANIFEST -p $CORES --scratch $INTERM

  cp $BASEDIR/rail-rna_logs/*.log $BASEDIR/$CORES.log
  rm -rf $BASEDIR/rail-rna_logs/
  rm -rf $BASEDIR/rail-rna_out/
done
