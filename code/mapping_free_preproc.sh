#!/bin/sh

#Reference transcriptome preparation

REF_T="/home/bioinformatikai/HW1/references/gencode.vM9.pc_transcripts.fa"
REF_T_INDEX="/home/bioinformatikai/HW1/references/gencode.vM9.pc_transcripts"

if [ -f "$REF_T_INDEX" ]; then
	echo "$REF_T_INDEX exists."
else
     salmon index -t ${REF_T} -i ${REF_T_INDEX}
fi

INPUT="/home/bioinformatikai/HW1/inputs"
OUTPUT="/home/bioinformatikai/HW1/outputs/fastqc"
OUTPUT2="/home/bioinformatikai/HW1/outputs/quantification"
OUTPUT3="/home/bioinformatikai/HW1/outputs/fastqcTrimmed"

for file in ${INPUT}/*.fastq.gz
do
  fastqc ${file} -o ${OUTPUT}
done

#MultiQC
multiqc -f ${OUTPUT} -o ${OUTPUT}

R1="/home/bioinformatikai/HW1/inputs/*_1.fastq.gz"
R2="/home/bioinformatikai/HW1/inputs/*_2.fastq.gz"

#Run trim_galore
for R1_file in ${R1}; do
  R2_file=${R1_file/_1.fastq.gz/_2.fastq.gz}
  trim_galore -j 6 --paired --quality 20 --length 20 "${R1_file}" "${R2_file}" -o ${OUTPUT3}
done

#rerun FASTQC
for file in ${OUTPUT3}/*.fq.gz
do
  fastqc -t 6 ${file} -o ${OUTPUT2}
done

#Quantify each sample
for file in ${OUTPUT2}/*_1_val_1.fq.gz
do
   base_name=$(basename ${file} _1_val_1.fq.gz)
   if [ -f ${OUTPUT2}${base_name}_2_val_2.fq.gz ]
   then
      salmon quant -i ${REF_T_INDEX} -l A -1 ${file} -2 ${OUTPUT2}${base_name}_2_val_2.gz -o ${OUTPUT2}${base_name}.quant
      echo "Quantification for ${base_name} is complete"
   else
      echo "File not found for ${base_name}_2_val_2.fq.gz"
   fi
done
