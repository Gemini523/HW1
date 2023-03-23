#!/bin/bash

# Reference genome preparation
REF_GENOME="/home/bioinformatikai/HW1/references/GRCm38.p4.genome.fa"
REF_INDEX="/home/bioinformatikai/HW1/references/GRCm38.p4.genome"

# Check if the index files exist
#for i in {1..8}
#do
# if [ ! -f "${REF_INDEX}.${i}.ht2" ]; then
#    echo "Reference genome index files do not exist. Creating index files.."
#    hisat2-build -p 6 ${REF_GENOME} ${REF_INDEX}
# else
#    echo "Reference genome index files already exist."
# fi
#done 

#////////////Data QC////////////////////////////////////////////////

INPUT="/home/bioinformatikai/HW1/inputs"
OUTPUT="/home/bioinformatikai/HW1/outputs/fastqc"
OUTPUT1="/home/bioinformatikai/HW1/outputs"
OUTPUT2="/home/bioinformatikai/HW1/outputs/fastqcTrimmed"
#for file in ${INPUT}/*.fastq.gz
#do
#  fastqc ${file} -o ${OUTPUT}
#done

# MultiQC
#multiqc -f ${OUTPUT} -o ${OUTPUT}

# Define input files
R1="/home/bioinformatikai/HW1/inputs/*_1.fastq.gz"
R2="/home/bioinformatikai/HW1/inputs/*_2.fastq.gz"

# Run trim_galore
#for R1_file in ${R1}; do
#  R2_file=${R1_file/_1.fastq.gz/_2.fastq.gz}
#  trim_galore -j 6 --paired --quality 20 --length 20 "${R1_file}" "${R2_file}" -o /home/bioinformatikai/HW1/outputs/
#done

#for file in ${OUTPUT1}/*.fq.gz
#do
#  fastqc -t 6 ${file} -o ${OUTPUT2}
#done

# Create MultiQC plots for raw and processed data
#multiqc -p /home/bioinformatikai/HW1/outputs/fastqc/
#multiqc -p /home/bioinformatikai/HW1/outputs/fastqcTrimmed/

#////////////Mapping, some QC and quantification//////////////////////
BAM="/home/bioinformatikai/HW1/outputs/bams"
#for file in ${OUTPUT1}/*_1_val_1.fq.gz
#do
#    sample=$(basename ${file} _1_val_1.fq.gz)
#
#    hisat2 -p 6 -x ${REF_INDEX} --dta -1 ${OUTPUT1}/"$sample"_1_val_1.fq.gz -2 ${OUTPUT1}/"$sample"_2_val_2.fq.gz -S ${OUTPUT1}/"$sample".sam
#done
for file in ${OUTPUT1}/*.sam
do
  echo $file 
   samtools view -bS $file -@ 6| samtools sort -@ 6 -o ${BAM}
   samtools fixmate -@ 6 -m ${BAM} /home/bioinformatikai/HW1/outputs/bams/fixmate.bam
   samtools sort -@ 6 -o /home/bioinformatikai/HW1/outputs/bams/sorted.bam /home/bioinformatikai/HW1/outputs/bams/fixmate.bam
   #samtools markdup -@ 6 -r /home/bioinformatikai/HW1/outputs/bams/sorted.bam
done

#REF_ANNOTATION="/home/bioinformatikai/HW1/references/gencode.vM9.annotation.gtf.gz"

#for file in *.sorted.bam
#do
#    sample=$(basename "$file" .sorted.bam)
#    stringtie "$file" -p 6 -G ${REF_ANNOTATION} -o ${OUTPUT1}/"$sample".gtf -l "$sample"
#done
