#!/bin/bash

CORES=16
START=6
END=15
BASEDIR=$(dirname "$0")

for (( n_rails=$START; n_rails<=$END; n_rails+=1 ))
do
	echo "${n_rails} instances" >> /home1/05096/rcao/testing/runtimes_${n_rails}.txt
	{ time sh $BASEDIR/rail_benchmark_parallel.sh -o /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/BowtieIndex/genome -t /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/Bowtie2Index/genome -m https://raw.githubusercontent.com/nellore/rail/master/ex/dm3_example.manifest -p $CORES -d /tmp -n $n_rails 2> rail.stderr ; } 2>> /home1/05096/rcao/testing/runtimes_${n_rails}.txt
	rm -rf /home1/05096/rcao/testing/parallel_logs/logs_*_rail/*out*/
done



#rail-rna go local -x /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/BowtieIndex/genome /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/Bowtie2Index/genome -m https://raw.githubusercontent.com/nellore/rail/master/ex/dm3_example.manifest -p 16
#./rail_benchmark_single.sh -o /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/BowtieIndex/genome -t /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/Bowtie2Index/genome -m https://raw.githubusercontent.com/nellore/rail/master/ex/dm3_example.manifest -p 4,8,16 -d /tmp

#start=`date +%s`
#for i in {1..5}
#do
#	rail-rna go local -x /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/BowtieIndex/genome /home1/05096/rcao/testing/Drosophila_melanogaster/UCSC/dm3/Sequence/Bowtie2Index/genome -m https://raw.githubusercontent.com/nellore/rail/master/ex/dm3_example.manifest -p 16 --scratch /tmp --output ./rail-rna_out_$i --log ./rail-rna_logs_$i &
#done
