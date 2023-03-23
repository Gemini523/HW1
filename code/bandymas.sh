#!/bin/bash

GENOME="/home/bioinformatikai/HW1/references/GRCm38.p4.genome.fa"
REF="/home/bioinformatikai/HW1/references/GRCm38.p4.genome.fa.*"


GTF="/home/bioinformatikai/HW1/references/gencode.vM9.annotation.gtf"

if [ -f "$REF" ]; then
    echo "Reference genome index files exist."
else 
    hisat2-build -p 6 ${GENOME} /home/bioinformatikai/HW1/references/GRCm38.p4.genome.fa
fi

for file in /home/bioinformatikai/HW1/inputs/*_1.fastq.gz
do

S1=${file}; base=$(basename ${file} _1.fastq.gz)
S2="/home/bioinformatikai/HW1/inputs/"$(basename ${S1} _1.fastq.gz)"_2.fastq.gz"

T1="/home/bioinformatikai/HW1/outputs/"$(basename ${file} _1.fastq.gz)"_1_val_1.fq.gz"
T2="/home/bioinformatikai/HW1/outputs/"$(basename ${file} _1.fastq.gz)"_2_val_2.fq.gz"

BAM="/home/bioinformatikai/HW1/outputs/bams/"$(basename ${file} _1.fastq.gz)".bam"
BAM_MARKDUP="/home/bioinformatikai/HW1/outputs/bams/"$(basename ${i} _1.fastq.gz)"markdup.bam"

hisat2 -p 6 /home/bioinformatikai/HW1/references/NCBIM37GRCm38.p4.genome.fa -1 ${T1} -2 ${T2} -S /home/bioinformatikai/HW1/outputs/temp.sam

samtools view -b -@ 6 /home/bioinformatikai/HW1/outputs/temp.sam | samtools sort -@ 6 -n - -o ${BAM}
samtools fixmate -@ 6 -m ${BAM} /home/bioinformatikai/HW1/outputs/bams/fixmate.bam
samtools sort -@ 6 -o /home/bioinformatikai/HW1/outputs/bams/sorted.bam /home/bioinformatikai/HW1/outputs/bams/fixmate.bam
samtools markdup -@ 6 -r /home/bioinformatikai/HW1/outputs/bams/sorted.bam ${BAM_MARKDUP}
done
