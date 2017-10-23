#!/bin/bash

for i in {1..5}
do
	cat dm3_example_1_left.fastq  >> dm3_example_1_left_x5.fastq
	cat dm3_example_2_left.fastq >> dm3_example_2_left_x5.fastq
done
