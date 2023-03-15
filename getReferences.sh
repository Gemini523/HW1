#!/bin/sh
#Mus Musculus mm9

#download transcriptome FASTA
wget -O ../refs/gencode.vM9.pc_transcripts.fa.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/gencode.vM9.pc_transcripts.fa.gz
#download gtf/gff3 files
wget -O ../refs/gencode.vM9.annotation.gtf.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/gencode.vM9.annotation.gtf.gz
wget -O ../refs/gencode.vM9.annotation.gff3.gz   https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/gencode.vM9.annotation.gff3.gz
#download genome FASTA
wget -O ../refs/GRCm38.p4.genome.fa.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/GRCm38.p4.genome.fa.gz

#download FASTQ files
fastq-dump --split-files -O ../inputs/ SRR8985047
fastq-dump --split-files -O ../inputs/ SRR8985048
fastq-dump --split-files -O ../inputs/ SRR8985051
fastq-dump --split-files -O ../inputs/ SRR8985052

#Calculate the number of protein-coding genes in your genome.
cd /home/bioinformatikai/HW1/references/
gunzip -c mm9.gtf.gz | grep -w "gene" | grep -w "protein_coding" | wc -l
