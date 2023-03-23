#!/bin/bash

# Reference genome preparation
REF_GENOME="/home/bioinformatikai/HW1/references/GRCm38.p4.genome.fa"
REF_INDEX="/home/bioinformatikai/HW1/references/GRCm38.p4.genome"

# Check if the index files exist
for i in {1..8}
do
 if [ ! -f "${REF_INDEX}.${i}.ht2" ]; then
    echo "Reference genome index files do not exist. Creating index files.."
      #hisat2-build -p 6 ${REF_GENOME} ${REF_INDEX}
	echo "${REF_INDEX}.${i}.ht2"
 else
    echo "egzist"
 fi
done
