#!/bin/bash

# Reference genome preparation
REF_GENOME="/home/bioinformatikai/HW1/references/GRCm38.p4.genome.fa"
REF_INDEX="/home/bioinformatikai/HW1/references/GRCm38.p4.genome"

# Check if the index files exist
for i in {1..8}
do
 if [ ! -f "${REF_INDEX}.${i}.ht2" ]; then
    echo "Reference genome index files do not exist. Creating index files.."
    hisat2-build -p 6 ${REF_GENOME} ${REF_INDEX}
 else
    echo "Reference genome index files already exist."
 fi
done 

#////////////Data QC////////////////////////////////////////////////

INPUT="/home/bioinformatikai/HW1/inputs"
OUTPUT="/home/bioinformatikai/HW1/outputs/fastqc"
OUTPUT1="/home/bioinformatikai/HW1/outputs"
OUTPUT2="/home/bioinformatikai/HW1/outputs/fastqcTrimmed"

for file in ${INPUT}/*.fastq.gz
do
  fastqc ${file} -o ${OUTPUT}
done

# MultiQC
multiqc -f ${OUTPUT} -o ${OUTPUT}

# Define input files
R1="/home/bioinformatikai/HW1/inputs/*_1.fastq.gz"
R2="/home/bioinformatikai/HW1/inputs/*_2.fastq.gz"

# Run trim_galore
for R1_file in ${R1}; do
  R2_file=${R1_file/_1.fastq.gz/_2.fastq.gz}
  trim_galore -j 6 --paired --quality 20 --length 20 "${R1_file}" "${R2_file}" -o /home/bioinformatikai/HW1/outputs/
done

for file in ${OUTPUT1}/*.fq.gz
do
  fastqc -t 6 ${file} -o ${OUTPUT2}
done

# Create MultiQC plots for raw and processed data
multiqc -p /home/bioinformatikai/HW1/outputs/fastqc/
multiqc -p /home/bioinformatikai/HW1/outputs/fastqcTrimmed/

#////////////Mapping, some QC and quantification//////////////////////
BAM1="/home/bioinformatikai/HW1/outputs/bams"

for i in ${OUTPUT1}/*_1.fq.gz;
do
#R1=${i};
#R2=${OUTPUT}/$(basename ${i} 1.fastq.gz)2.fastq.gz;
BAM=${OUTPUT1}/$(basename ${i} 1_val_1.fq.gz).bam
OUT1=${OUTPUT1}/$(basename ${i})
OUT2=${OUTPUT1}/$(basename ${i} 1_val_1.fq.gz)2_val_2.fq.gz

hisat2 -p 6 --no-mixed --no-discordant --no-unal -x ${REF_INDEX} -1 ${OUT1} -2 ${OUT2} -S ${OUTPUT1}/tmp.sam

samtools view -@ 6 -bS ${OUTPUT1}/tmp.sam | samtools sort -@ 6 -o tmp.bam
rm ${OUTPUT1}/tmp.sam
#echo "$i view"
samtools sort -@ 6 -n tmp.bam -o foo.bam
#echo "$i sort1"
samtools fixmate -@ 6 -m -r foo.bam bar.bam
#echo "$i fixmate"
samtools sort -@ 6 bar.bam > foo.bam
#echo "$i sort2"
samtools markdup -@ 6 -r foo.bam bar.bam
#echo "$i markdup"
samtools sort -@ 6 bar.bam -o ${BAM}
#echo "$i sort3"
samtools index ${BAM}
#echo "$i index" 
done
#echo "done"
rm ${BAM1}/tmp.bam ${BAM1}/bar.bam ${BAM1}/foo.bam

GTF="/home/bioinformatikai/HW1/references/gencode.vM9.annotation.gtf"
ALIGNED="/home/bioinformatikai/HW1/outputs/aligned"
TMP="/home/bioinformatikai/HW1/TMP"
REZ="/home/bioinformatikai/HW1/results"

for i in ${OUTPUT1}/*.bam
 do
    NAME=$(basename ${i} .gtf)
    stringtie -p 6 -eB -G ${GTF} -o ${ALIGNED}/${NAME} -A ${TMP}/${NAME}.tab ${i}
done

# Correlation diagram, PCA plot, scatter plot
multiqc -o ${REZ} ${OUTPUT1}
multiBamSummary bins --bamfiles ${OUTPUT1}/*.bam --numberOfProcessors 6 --binSize 1000 --outFileName ${REZ}/data.npz --outRawCounts ${REZ}/rawcounts.tsv 
plotCorrelation --corData ${REZ}/data.npz --corMethod spearman --whatToPlot heatmap --plotNumbers --plotFile ${REZ}/heatmap.pdf
plotCorrelation --corData ${REZ}/data.npz --corMethod spearman --whatToPlot scatterplot --plotFile ${REZ}/scatterplot.pdf
plotPCA --corData ${REZ}/data.npz --plotFile ${REZ}/PCA.pdf
